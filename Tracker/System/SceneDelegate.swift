import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Private Constants
    private enum Constants {
        static let hasCompletedOnboardingKey = "hasCompletedOnboarding"
    }
    
    // MARK: - Properties
    var window: UIWindow?
    
    // MARK: - UISceneDelegate
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: Constants.hasCompletedOnboardingKey)
        
        if hasCompletedOnboarding {
            let context = CoreDataStack.shared.context
            window?.rootViewController = TabBarController(context: context)
        } else {
            let onboardingVC = OnboardingViewController()
            onboardingVC.onCompletion = { [weak self] in
                UserDefaults.standard.set(true, forKey: Constants.hasCompletedOnboardingKey)
                self?.switchToMainScreenAnimated()
            }
            window?.rootViewController = onboardingVC
        }
        
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Private Methods
    private func switchToMainScreenAnimated() {
        guard let window = window else { return }
        
        let context = CoreDataStack.shared.context
        window.rootViewController = TabBarController(context: context)
        
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
