import UIKit

final class TrackerViewController: UIViewController, TrackerStoreDelegate {

    // MARK: - Properties
    private let trackerStore: TrackerStore
    private let trackerCategoryStore: TrackerCategoryStore
    let trackerRecordStore: TrackerRecordStore

    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var visibleCategories: [TrackerCategory] = []
    var currentDate: Date = Date()

    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.textColor = UIColor(resource: .blackDay)
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()

    let addTrackerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(resource: .addTracker), for: .normal)
        button.tintColor = .black
        return button
    }()

    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.layer.cornerRadius = 8
        picker.clipsToBounds = true
        return picker
    }()

    let searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Поиск"
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(resource: .grayYP)
        return textField
    }()

    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .starBackground)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.textColor = UIColor(resource: .blackDay)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
        return collection
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
        view.backgroundColor = .white

        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier
        )
        collectionView.register(
            TrackerHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView
                .elementKindSectionHeader,
            withReuseIdentifier: TrackerHeaderView.identifier
        )

        setupTitleLabel()
        setupAddButton()
        setupDatePicker()
        setupSearchTextField()
        setupCollectionView()
        setupBackgroundImage()
        setupSubtitleLabel()

        self.completedTrackers = trackerRecordStore.records
        filterTrackers(for: currentDate)
    }

    // MARK: - Actions & Filtering
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        filterTrackers(for: currentDate)
    }

    @objc func searchTextFieldChanged() {
        filterTrackers(for: currentDate)
    }

    @objc func addTrackerButtonTapped() {
        let createTrackerVC = CreateTrackerViewController()
        createTrackerVC.delegate = self
        present(createTrackerVC, animated: true)
    }

    private func filterTrackers(for date: Date) {
        let calendar = Calendar.current
        let weekDayComponent = calendar.component(.weekday, from: date)
        let targetRawValue = weekDayComponent == 1 ? 7 : weekDayComponent - 1

        guard let currentWeekDay = WeekDay(rawValue: targetRawValue) else {
            return
        }

        let allTrackers = trackerStore.trackers
        let filteredTrackers = allTrackers.filter { tracker in
            tracker.schedule.contains(currentWeekDay)
        }

        if !filteredTrackers.isEmpty {
            self.visibleCategories = [
                TrackerCategory(
                    title: String(localized: "create_tracker_category"),
                    trackers: filteredTrackers
                )
            ]
        } else {
            self.visibleCategories = []
        }

        collectionView.reloadData()

        let isTrackersEmpty = visibleCategories.isEmpty
        backgroundImage.isHidden = !isTrackersEmpty
        subtitleLabel.isHidden = !isTrackersEmpty
    }

}

// MARK: - CreateTrackerViewControllerDelegate
extension TrackerViewController: CreateTrackerViewControllerDelegate {
    func didCreateTracker(_ tracker: Tracker, toCategory title: String) {
        var newCategories: [TrackerCategory] = []
        var categoryFound = false

        for category in categories {
            if category.title == title {
                var updatedTrackers = category.trackers
                updatedTrackers.append(tracker)
                let updatedCategory = TrackerCategory(
                    title: category.title,
                    trackers: updatedTrackers
                )
                newCategories.append(updatedCategory)
                categoryFound = true
            } else {
                newCategories.append(category)
            }
        }

        if !categoryFound {
            let newCategory = TrackerCategory(title: title, trackers: [tracker])
            newCategories.append(newCategory)
        }

        self.categories = newCategories
        filterTrackers(for: currentDate)
    }

    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        filterTrackers(for: currentDate)
    }
}
