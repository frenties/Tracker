import Foundation
import UIKit

final class TrackerMockData {
    static func setupMockCategories() -> [TrackerCategory] {
        let testTrackerID = UUID()
        
        let testTracker = Tracker(
            id: testTrackerID,
            name: "Поливать растения",
            color: UIColor(resource: .greenYP),
            emoji: "🪴",
            schedule: [.monday,  .wednesday, .friday]
        )
        
        let testCategory = TrackerCategory(
            title: "Домашний уют",
            trackers: [testTracker]
        )
        
        return [testCategory]
    }
}


