import Foundation
import UIKit

final class TrackerViewController: UIViewController {
    
    // MARK: - Properties
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
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()
    
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
        
        if categories.isEmpty {
            self.categories = TrackerMockData.setupMockCategories()
        }
        
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
    
    func filterTrackers(for date: Date) {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        
        let weekDayIndex = calendar.component(.weekday, from: date)
        let targetWeekDay = weekDayIndex == 1 ? WeekDay.sunday : WeekDay(rawValue: weekDayIndex - 1)
        
        guard let currentWeekDay = targetWeekDay else { return }
        let searchText = searchTextField.text?.lowercased() ?? ""
        
        visibleCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let matchesDate = tracker.schedule.contains(currentWeekDay)
                let matchesSearch = searchText.isEmpty || tracker.name.lowercased().contains(searchText)
                return matchesDate && matchesSearch
            }
            
            if filteredTrackers.isEmpty { return nil }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
        
        let isTrackersListEmpty = visibleCategories.isEmpty
        backgroundImage.isHidden = isTrackersListEmpty == false
        subtitleLabel.isHidden = isTrackersListEmpty == false
        
        collectionView.reloadData()
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
                let updatedCategory = TrackerCategory(title: category.title, trackers: updatedTrackers)
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
}

