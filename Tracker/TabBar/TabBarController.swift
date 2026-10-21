import UIKit

final class TabBarController: UITabBarController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
        setupTabBar()
    }
    
    // MARK: - Setup UI
    private func setupTabs() {
        let trackerViewController = TrackerViewController()
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
        
        trackerNavigationController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .trackersIteam),
            selectedImage: nil
        )
        
        let statisticViewController = StatisticViewController()
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .statisticItem),
            selectedImage: nil
        )
        
        viewControllers = [trackerNavigationController, statisticViewController]
    }
    
    private func setupTabBar() {
        view.backgroundColor = .white
        tabBar.backgroundColor = .white
        
        tabBar.tintColor = UIColor(resource: .blueYP)
        tabBar.unselectedItemTintColor = UIColor(resource: .grayYP)
    }
}

