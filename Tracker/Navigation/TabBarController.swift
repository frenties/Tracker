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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
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
            title: String(localized: "tab_trackers"),
            image: Asset.trackersIteam.image,
            selectedImage: nil
        )
        
        let statisticViewController = StatisticViewController(
            trackerRecordStore: trackerRecordStore,
            trackerCategoryStore: trackerCategoryStore
        )
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: String(localized: "tab_statistic"),
            image: Asset.statisticItem.image,
            selectedImage: nil
        )
        
        viewControllers = [trackerNavigationController, statisticViewController]
    }
    
    private func setupTabBar() {
        view.backgroundColor = Asset.whiteDay.color
        tabBar.backgroundColor = Asset.whiteDay.color
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Asset.whiteDay.color
        appearance.shadowColor = Asset.grayYP.color
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.tintColor = Asset.blueYP.color
        tabBar.unselectedItemTintColor = Asset.grayYP.color
    }
}
