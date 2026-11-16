import XCTest
import CoreData
import SnapshotTesting

@testable import Tracker

final class TrackerTests: XCTestCase {
    
    // MARK: - Helpers
    private func makeFixedDate() throws -> Date {
        let components = DateComponents(year: 2026, month: 11, day: 16)
        return try XCTUnwrap(
            Calendar.current.date(from: components),
            "Failed to create fixed date"
        )
    }
    
    private func makeInMemoryContext() throws -> NSManagedObjectContext {
        let bundle = Bundle(for: TrackerStore.self)
        let modelURL = try XCTUnwrap(
            bundle.url(forResource: "Tracker", withExtension: "momd"),
            "Failed to find Tracker.momd in bundle"
        )
        let model = try XCTUnwrap(
            NSManagedObjectModel(contentsOf: modelURL),
            "Failed to initialize NSManagedObjectModel"
        )
        
        let container = NSPersistentContainer(name: "Tracker", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        var loadError: Error?
        container.loadPersistentStores { _, error in
            loadError = error
        }
        
        if let loadError {
            throw loadError
        }
        
        return container.viewContext
    }
    
    private func makeTrackerViewController() throws -> TrackerViewController {
        let context = try makeInMemoryContext()
        let trackerStore = TrackerStore(context: context)
        let trackerCategoryStore = TrackerCategoryStore(context: context)
        let trackerRecordStore = TrackerRecordStore(context: context)
        
        let vc = TrackerViewController(
            trackerStore: trackerStore,
            trackerCategoryStore: trackerCategoryStore,
            trackerRecordStore: trackerRecordStore
        )
        
        let fixedDate = try makeFixedDate()
        vc.currentDate = fixedDate
        vc.datePicker.date = fixedDate
        
        return vc
    }
    
    // MARK: - Snapshot Tests
    func testTrackerViewControllerLightTheme() throws {
        let vc = try makeTrackerViewController()
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .light))
        )
    }
    
    func testTrackerViewControllerDarkTheme() throws {
        let vc = try makeTrackerViewController()
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .dark))
        )
    }
}
