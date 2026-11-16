import UIKit
import CoreData
import OSLog

// MARK: - TrackerStoreUpdate
struct TrackerStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
}

// MARK: - TrackerStoreDelegate
protocol TrackerStoreDelegate: AnyObject {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate)
}

// MARK: - TrackerStore
final class TrackerStore: NSObject {
    
    // MARK: - Public Properties
    weak var delegate: TrackerStoreDelegate?
    
    var trackers: [Tracker] {
        guard let objects = fetchedResultsController.fetchedObjects else { return [] }
        return objects.compactMap { coreDataTracker in
            let daysComponents = (coreDataTracker.value(forKey: "schedule") as? String ?? "").components(separatedBy: ",")
            let schedule = daysComponents.compactMap { Int($0) }.compactMap { WeekDay(rawValue: $0) }
            
            let colorIndex = Int(coreDataTracker.color ?? "0") ?? 0
            let color = (colorIndex >= 0 && colorIndex < UIConstants.colors.count)
            ? UIConstants.colors[colorIndex]
            : UIConstants.colors[0]
            
            return Tracker(
                id: coreDataTracker.id ?? UUID(),
                name: coreDataTracker.name ?? "",
                color: color,
                emoji: coreDataTracker.emoji ?? "🙂",
                schedule: schedule,
                isPinned: coreDataTracker.isPinned
            )
        }
    }
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet = []
    private var deletedIndexes: IndexSet = []
    private var updatedIndexes: IndexSet = []
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.tracker.app", category: "TrackerStore")
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            logger.error("Failed to perform fetch in TrackerStore: \(error.localizedDescription)")
        }
        
        return controller
    }()
    
    // MARK: - Initializers
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        try? fetchedResultsController.performFetch()
    }
    
    // MARK: - Public Methods
    func addNewTracker(_ tracker: Tracker, toCategory categoryTitle: String) {
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.isPinned = tracker.isPinned
        
        let colorIndex = UIConstants.colors.firstIndex(where: { $0.cgColor == tracker.color.cgColor }) ?? 0
        trackerCoreData.color = String(colorIndex)
        
        trackerCoreData.setValue(convertScheduleToString(tracker.schedule), forKey: "schedule")
        
        let categoryFetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        categoryFetchRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
        
        if let existingCategory = try? context.fetch(categoryFetchRequest).first {
            trackerCoreData.category = existingCategory
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = categoryTitle
            trackerCoreData.category = newCategory
        }
        
        CoreDataStack.shared.saveContext()
    }
    
    func updateTracker(_ tracker: Tracker, toCategory categoryTitle: String) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as NSObject)
        
        guard let trackerCoreData = try? context.fetch(fetchRequest).first else { return }
        
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.isPinned = tracker.isPinned
        
        let colorIndex = UIConstants.colors.firstIndex(where: { $0.cgColor == tracker.color.cgColor }) ?? 0
        trackerCoreData.color = String(colorIndex)
        trackerCoreData.setValue(convertScheduleToString(tracker.schedule), forKey: "schedule")
        
        let categoryFetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        categoryFetchRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
        
        if let existingCategory = try? context.fetch(categoryFetchRequest).first {
            trackerCoreData.category = existingCategory
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = categoryTitle
            trackerCoreData.category = newCategory
        }
        
        CoreDataStack.shared.saveContext()
    }
    
    func categoryTitle(for trackerId: UUID) -> String? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as NSObject)
        return (try? context.fetch(fetchRequest).first)?.category?.title
    }
    
    func togglePin(for trackerId: UUID) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as NSObject)
        
        guard let trackerCoreData = try? context.fetch(fetchRequest).first else { return }
        trackerCoreData.isPinned.toggle()
        CoreDataStack.shared.saveContext()
    }
    
    func deleteTracker(with id: UUID) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as NSObject)
        
        if let trackersToDelete = try? context.fetch(fetchRequest) {
            trackersToDelete.forEach { context.delete($0) }
            CoreDataStack.shared.saveContext()
        }
    }
    
    // MARK: - Private Methods
    private func convertScheduleToString(_ schedule: [WeekDay]) -> String {
        schedule.map { "\($0.rawValue)" }.joined(separator: ",")
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
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
        case .update:
            if let indexPath = indexPath { updatedIndexes.insert(indexPath.item) }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let update = TrackerStoreUpdate(
            insertedIndexes: insertedIndexes,
            deletedIndexes: deletedIndexes,
            updatedIndexes: updatedIndexes
        )
        delegate?.store(self, didUpdate: update)
    }
}
