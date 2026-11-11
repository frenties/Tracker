import Foundation

// MARK: - CategoryListViewModel
final class CategoryListViewModel: NSObject {
    
    // MARK: - Properties
    var categoriesBinding: (([CategoryViewModel]) -> Void)?

    var onCategorySelected: ((String) -> Void)?
    
    private(set) var categories: [CategoryViewModel] = [] {
        didSet {
            categoriesBinding?(categories)
        }
    }
    
    private let trackerCategoryStore: TrackerCategoryStore
    
    // MARK: - Initializers
    init(trackerCategoryStore: TrackerCategoryStore) {
        self.trackerCategoryStore = trackerCategoryStore
        super.init()
        
        self.trackerCategoryStore.delegate = self
        fetchCategories()
    }
    
    // MARK: - Public Methods
    func fetchCategories() {
        let savedCategoriesCoreData = trackerCategoryStore.fetchedCategories
        
        self.categories = savedCategoriesCoreData.compactMap { coreDataCategory in
            guard let title = coreDataCategory.title else { return nil }
            return CategoryViewModel(title: title)
        }
    }
    
    func addNewCategory(named title: String) {
        let category = TrackerCategory(title: title, trackers: [])
        try? trackerCategoryStore.addNewCategory(category)
        fetchCategories()
    }
    
    func deleteCategory(at index: Int) {
        guard index < categories.count else { return }
        
        try? trackerCategoryStore.deleteCategory(at: index)
        fetchCategories()
    }

}

// MARK: - TrackerCategoryStoreDelegate
extension CategoryListViewModel: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        fetchCategories()
    }
}

