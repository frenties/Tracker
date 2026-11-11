import Foundation

final class UserDefaultsService {
    
    // MARK: - Singleton
    static let shared = UserDefaultsService()
    
    // MARK: - Private Properties
    private let defaults = UserDefaults.standard
    
    private enum Key {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Properties
    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: Key.hasCompletedOnboarding) }
        set { defaults.set(newValue,
                           forKey: Key.hasCompletedOnboarding) }
    }
}
