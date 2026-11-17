import UIKit
import CoreData

// MARK: - TrackerRecordStoreUpdate
struct TrackerRecordStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}

// MARK: - TrackerRecordStoreDelegate
protocol TrackerRecordStoreDelegate: AnyObject {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate)
}

// MARK: - TrackerRecordStore
final class TrackerRecordStore: NSObject {
    
    // MARK: - Public Properties
    weak var delegate: TrackerRecordStoreDelegate?
    
    var records: [TrackerRecord] {
        try? fetchedResultsController.performFetch()
        guard let objects = fetchedResultsController.fetchedObjects else { return [] }
        return objects.map { coreDataRecord in
            TrackerRecord(
                id: coreDataRecord.id ?? UUID(),
                date: coreDataRecord.date ?? Date()
            )
        }
    }
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet = []
    private var deletedIndexes: IndexSet = []
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        
        return controller
    }()
    
    // MARK: - Initializers
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        try? fetchedResultsController.performFetch()
    }
    
    // MARK: - Public Methods
    func addRecord(_ record: TrackerRecord) {
        let calendar = Calendar.current
        let dateStart = calendar.startOfDay(for: record.date)
        guard let dateEnd = calendar.date(byAdding: .day, value: 1, to: dateStart) else {
            return
        }
        
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.predicate = NSPredicate(
            format: "id == %@ AND date >= %@ AND date < %@",
            record.id as NSObject,
            dateStart as NSObject,
            dateEnd as NSObject
        )
        
        let existingCount = (try? context.count(for: fetchRequest)) ?? 0
        guard existingCount == 0 else { return }
        
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.id = record.id
        recordCoreData.date = dateStart
        
        CoreDataStack.shared.saveContext()
    }
    
    func removeRecord(_ record: TrackerRecord) {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let calendar = Calendar.current
        let dateStart = calendar.startOfDay(for: record.date)
        
        guard let dateEnd = calendar.date(byAdding: .day, value: 1, to: dateStart) else {
            return
        }
        
        fetchRequest.predicate = NSPredicate(
            format: "id == %@ AND date >= %@ AND date < %@",
            record.id as NSObject,
            dateStart as NSObject,
            dateEnd as NSObject
        )
        
        if let records = try? context.fetch(fetchRequest) {
            for recordCoreData in records {
                context.delete(recordCoreData)
            }
            CoreDataStack.shared.saveContext()
        }
    }
    
    func deleteAllRecords(for trackerId: UUID) {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as NSObject)
        
        if let recordsToDelete = try? context.fetch(fetchRequest) {
            recordsToDelete.forEach { context.delete($0) }
            CoreDataStack.shared.saveContext()
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath { insertedIndexes.insert(newIndexPath.item) }
        case .delete:
            if let indexPath = indexPath { deletedIndexes.insert(indexPath.item) }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let update = TrackerRecordStoreUpdate(
            insertedIndexes: insertedIndexes,
            deletedIndexes: deletedIndexes
        )
        delegate?.store(self, didUpdate: update)
    }
}
