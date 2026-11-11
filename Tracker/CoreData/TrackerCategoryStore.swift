import UIKit
import CoreData

// MARK: - TrackerCategoryStoreUpdate
struct TrackerCategoryStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}

// MARK: - TrackerCategoryStoreDelegate
protocol TrackerCategoryStoreDelegate: AnyObject {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate)
}

// MARK: - TrackerCategoryStore
final class TrackerCategoryStore: NSObject {
    
    // MARK: - Public Properties
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var fetchedCategories: [TrackerCategoryCoreData] {
        fetchedResultsController.fetchedObjects ?? []
    }
    
    var categories: [TrackerCategory] {
        try? fetchedResultsController.performFetch()
        guard let objects = fetchedResultsController.fetchedObjects else { return [] }
        
        return objects.compactMap { categoryCoreData in
            guard let title = categoryCoreData.title else { return nil }
            
            let trackersSet = categoryCoreData.trackers as? Set<TrackerCoreData> ?? []
            let trackers: [Tracker] = trackersSet.compactMap { coreDataTracker in
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
                    schedule: schedule
                )
            }
            
            return TrackerCategory(title: title, trackers: trackers)
        }
    }
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet = []
    private var deletedIndexes: IndexSet = []
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
        
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
    func addNewCategory(_ category: TrackerCategory) throws {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = category.title
        categoryCoreData.trackers = NSSet()
        
        try context.save()
    }
    
    func deleteCategory(at index: Int) throws {
        let objects = fetchedResultsController.fetchedObjects ?? []
        guard index < objects.count else { return }
        
        let categoryToDelete = objects[index]
        context.delete(categoryToDelete)
        try context.save()
    }
    
    static func makeDefaultStore() -> TrackerCategoryStore? {
        return TrackerCategoryStore(context: CoreDataStack.shared.context)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
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
        let update = TrackerCategoryStoreUpdate(
            insertedIndexes: insertedIndexes,
            deletedIndexes: deletedIndexes
        )
        delegate?.store(self, didUpdate: update)
    }
}
