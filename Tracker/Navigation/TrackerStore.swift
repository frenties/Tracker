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
         
            let color = UIConstants.colors.first { colorToHexString($0) == coreDataTracker.color } ?? .gray
            
            return Tracker(
                id: coreDataTracker.id ?? UUID(),
                name: coreDataTracker.name ?? "",
                color: color,
                emoji: coreDataTracker.emoji ?? "🙂",
                schedule: schedule
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
    
    func addNewTracker(_ tracker: Tracker) {
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = colorToHexString(tracker.color)
        trackerCoreData.emoji = tracker.emoji
        
        trackerCoreData.setValue(convertScheduleToString(tracker.schedule), forKey: "schedule")
        
        let categoryFetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        categoryFetchRequest.predicate = NSPredicate(format: "title == %@", "Важное")
        
        if let existingCategory = try? context.fetch(categoryFetchRequest).first {
            trackerCoreData.category = existingCategory
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = "Важное"
            trackerCoreData.category = newCategory
        }
        
        CoreDataStack.shared.saveContext()
    }
    
    // MARK: - Private Methods
    private func convertScheduleToString(_ schedule: [WeekDay]) -> String {
        schedule.map { "\($0.rawValue)" }.joined(separator: ",")
    }
    
    private func colorToHexString(_ color: UIColor) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard color.getRed(&r, green: &g, blue: &b, alpha: &a) else { return "#000000" }
        
        return String(
            format: "#%02X%02X%02X",
            Int(r * 255),
            Int(g * 255),
            Int(b * 255)
        )
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

