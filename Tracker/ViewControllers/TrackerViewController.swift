import UIKit

final class TrackerViewController: UIViewController, TrackerStoreDelegate {
    
    // MARK: - Properties
    let trackerStore: TrackerStore
    private let trackerCategoryStore: TrackerCategoryStore
    let trackerRecordStore: TrackerRecordStore
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var visibleCategories: [TrackerCategory] = []
    var currentDate: Date = Date()
    var selectedFilter: TrackerFilter = .all
    
    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "trackers_title")
        label.textColor = Asset.blackDay.color
        label.font = UIFont.systemFont(ofSize: UIConstants.mainTitleFontSize, weight: .bold)
        return label
    }()
    
    let addTrackerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Asset.addTracker.image, for: .normal)
        button.tintColor = Asset.blackDay.color
        return button
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale.current
        picker.layer.cornerRadius = UIConstants.datePickerCornerRadius
        picker.clipsToBounds = true
        return picker
    }()
    
    let searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = String(localized: "search_placeholder")
        textField.layer.cornerRadius = UIConstants.searchFieldCornerRadius
        textField.backgroundColor = Asset.grayYP.color
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Asset.starBackground.image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "empty_trackers_placeholder")
        label.textColor = Asset.blackDay.color
        label.font = UIFont.systemFont(ofSize: UIConstants.mainSubtitleFontSize, weight: .medium)
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.keyboardDismissMode = .onDrag
        collection.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: UIConstants.collectionBottomInsetWithFilters,
            right: 0
        )
        return collection
    }()
    
    let filtersButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String(localized: "filters_button_title"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.categoryTextFieldFontSize, weight: .regular)
        button.backgroundColor = Asset.blueYP.color
        button.layer.cornerRadius = UIConstants.cornerRadius
        return button
    }()
    
    // MARK: - Initializers
    init(
        trackerStore: TrackerStore,
        trackerCategoryStore: TrackerCategoryStore,
        trackerRecordStore: TrackerRecordStore
    ) {
        self.trackerStore = trackerStore
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore
        
        super.init(nibName: nil, bundle: nil)
        
        self.trackerStore.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.whiteDay.color
        
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier
        )
        collectionView.register(
            TrackerHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerHeaderView.identifier
        )
        
        setupTitleLabel()
        setupAddButton()
        setupDatePicker()
        setupSearchTextField()
        setupCollectionView()
        setupBackgroundImage()
        setupSubtitleLabel()
        setupFiltersButton()
        setupInteractions()
        
        self.completedTrackers = trackerRecordStore.records
        filterTrackers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.shared.report(event: .open, screen: .main)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.shared.report(event: .close, screen: .main)
    }
    
    // MARK: - Actions & Filtering
    private func setupInteractions() {
        searchTextField.delegate = self
        
        searchTextField.addAction(
            UIAction { [weak self] _ in
                self?.filterTrackers()
            },
            for: .editingChanged
        )
        
        datePicker.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                self.currentDate = self.datePicker.date
                if self.selectedFilter == .today {
                    self.selectedFilter = .all
                }
                self.filterTrackers()
            },
            for: .valueChanged
        )
        
        addTrackerButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                AnalyticsService.shared.report(event: .click, screen: .main, item: .addTrack)
                let createTrackerVC = CreateTrackerViewController()
                createTrackerVC.delegate = self
                self.present(createTrackerVC, animated: true)
            },
            for: .touchUpInside
        )
        
        filtersButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                AnalyticsService.shared.report(event: .click, screen: .main, item: .filter)
                let filtersVC = FiltersViewController(selectedFilter: self.selectedFilter)
                filtersVC.onSelectFilter = { [weak self] chosenFilter in
                    guard let self else { return }
                    self.selectedFilter = chosenFilter
                    if chosenFilter == .today {
                        self.currentDate = Date()
                        self.datePicker.date = self.currentDate
                    }
                    self.filterTrackers()
                }
                self.present(filtersVC, animated: true)
            },
            for: .touchUpInside
        )
    }
    
    func filterTrackers() {
        guard let currentWeekDay = WeekDay(date: currentDate) else {
            return
        }
        
        let query = (searchTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let isSearching = !query.isEmpty
        
        let allCategories = trackerCategoryStore.categories
        let hasAnyTrackersForDay = allCategories.contains { category in
            category.trackers.contains { $0.schedule.contains(currentWeekDay) }
        }
        filtersButton.isHidden = !hasAnyTrackersForDay
        
        var pinnedTrackers: [Tracker] = []
        
        let regularCategories: [TrackerCategory] = allCategories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let matchesDate = tracker.schedule.contains(currentWeekDay)
                let matchesSearch = !isSearching || tracker.name.localizedStandardContains(query)
                let isCompletedToday = completedTrackers.contains { record in
                    record.id == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: currentDate)
                }
                
                let matchesFilter: Bool
                switch selectedFilter {
                case .all, .today:
                    matchesFilter = true
                case .completed:
                    matchesFilter = isCompletedToday
                case .uncompleted:
                    matchesFilter = !isCompletedToday
                }
                
                return matchesDate && matchesSearch && matchesFilter
            }
            
            let pinnedInCategory = filteredTrackers.filter { $0.isPinned }
            let unpinnedInCategory = filteredTrackers.filter { !$0.isPinned }
            
            pinnedTrackers.append(contentsOf: pinnedInCategory)
            
            guard !unpinnedInCategory.isEmpty else { return nil }
            return TrackerCategory(title: category.title, trackers: unpinnedInCategory)
        }
        
        var resultCategories: [TrackerCategory] = []
        if !pinnedTrackers.isEmpty {
            resultCategories.append(
                TrackerCategory(
                    title: String(localized: "pinned_category_title"),
                    trackers: pinnedTrackers
                )
            )
        }
        resultCategories.append(contentsOf: regularCategories)
        visibleCategories = resultCategories
        collectionView.reloadData()
        updateEmptyState(isSearching: isSearching || selectedFilter.isActiveFilter)
    }
    private func updateEmptyState(isSearching: Bool) {
        let isTrackersEmpty = visibleCategories.isEmpty
        backgroundImage.isHidden = !isTrackersEmpty
        subtitleLabel.isHidden = !isTrackersEmpty
        guard isTrackersEmpty else { return }
        if isSearching {
            backgroundImage.image = Asset.nothingFound.image
            subtitleLabel.text = String(localized: "nothing_found_placeholder")
        } else {
            backgroundImage.image = Asset.starBackground.image
            subtitleLabel.text = String(localized: "empty_trackers_placeholder")
        }
    }
}
// MARK: - CreateTrackerViewControllerDelegate
extension TrackerViewController: CreateTrackerViewControllerDelegate {
    func didCreateTracker(_ tracker: Tracker, toCategory title: String) {
        trackerStore.addNewTracker(tracker, toCategory: title)
        filterTrackers()
    }
    func didUpdateTracker(_ tracker: Tracker, toCategory title: String) {
        trackerStore.updateTracker(tracker, toCategory: title)
        filterTrackers()
    }
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        filterTrackers()
    }
}
// MARK: - UITextFieldDelegate
extension TrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
