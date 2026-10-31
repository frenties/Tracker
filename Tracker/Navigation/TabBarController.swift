import Foundation
import UIKit
import CoreData

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    private let context: NSManagedObjectContext
    
    // MARK: - Initializers
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBar()
    }
    
    // MARK: - Setup UI
    private func setupTabs() {

        let trackerStore = TrackerStore(context: context)
        let trackerCategoryStore = TrackerCategoryStore(context: context)
        let trackerRecordStore = TrackerRecordStore(context: context)

        let trackerViewController = TrackerViewController(
            trackerStore: trackerStore,
            trackerCategoryStore: trackerCategoryStore,
            trackerRecordStore: trackerRecordStore
        )
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

