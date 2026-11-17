import Foundation
import OSLog
import YandexMobileMetrica

final class AnalyticsService {
    
    static let shared = AnalyticsService()
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.tracker.app",
        category: "AnalyticsService"
    )
    
    private init() {}
    
    static func activate(apiKey: String) {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: apiKey) else {
            return
        }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: Event, screen: Screen = .main, item: Item? = nil) {
        var params: [AnyHashable: Any] = [
            "event": event.rawValue,
            "screen": screen.rawValue
        ]
        
        if let item {
            params["item"] = item.rawValue
        }
        
        logger.info("Analytics event: \(String(describing: params))")
        
        YMMYandexMetrica.reportEvent(
            "ui_event",
            parameters: params,
            onFailure: { [weak self] error in
                self?.logger.error("REPORT ERROR: \(error.localizedDescription)")
            }
        )
    }
}

// MARK: - Event Types
extension AnalyticsService {
    
    enum Event: String {
        case open
        case close
        case click
    }
    
    enum Screen: String {
        case main = "Main"
    }
    
    enum Item: String {
        case addTrack = "add_track"
        case track = "track"
        case filter = "filter"
        case edit = "edit"
        case delete = "delete"
    }
}
