import UIKit

final class TabBarController: UITabBarController {
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
        setupTabBar()
    }
    
    private func setupTabs() {
        
        let trackerViewController = TrackerViewController()
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .trackersIteam),
            selectedImage: nil
        )
        
        let statisticViewController = StatiscticViewController()
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .statisticItem),
            selectedImage: nil
        )
        
        viewControllers = [trackerViewController, statisticViewController]
    }
    
    private func setupTabBar() {
        view.backgroundColor = .white
        tabBar.backgroundColor = .white
        
        tabBar.tintColor = UIColor(resource: .blueYP)
        tabBar.unselectedItemTintColor = UIColor(resource: .grayYP)
    }
}

