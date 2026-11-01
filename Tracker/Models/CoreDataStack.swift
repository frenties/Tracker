import Foundation
import CoreData
import OSLog

final class CoreDataStack {
    
    // MARK: - Static Properties
    static let shared = CoreDataStack()
    
    // MARK: - Private Properties
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.tracker.app", category: "CoreDataStack")
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores { [weak self] (storeDescription, error) in
            if let error = error as NSError? {
                self?.logger.fault("Unresolved error initializing Persistent Store: \(error.localizedDescription), \(error.userInfo)")
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving Support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                logger.error("Context save failed: \(nserror.localizedDescription), \(nserror.userInfo)")
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

