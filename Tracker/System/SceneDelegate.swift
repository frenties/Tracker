import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    var window: UIWindow?
    
    // MARK: - UISceneDelegate
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        if UserDefaultsService.shared.hasCompletedOnboarding {
            let context = CoreDataStack.shared.context
            window?.rootViewController = TabBarController(context: context)
        } else {
            let onboardingVC = OnboardingViewController()
            onboardingVC.onCompletion = { [weak self] in
                UserDefaultsService.shared.hasCompletedOnboarding = true
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
}
