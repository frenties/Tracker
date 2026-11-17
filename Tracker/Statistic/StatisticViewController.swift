import UIKit

final class StatisticViewController: UIViewController {
    
    // MARK: - Properties
    private let trackerRecordStore: TrackerRecordStore
    private let trackerCategoryStore: TrackerCategoryStore
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "tab_statistic")
        label.textColor = Asset.blackDay.color
        label.font = UIFont.systemFont(ofSize: UIConstants.mainTitleFontSize, weight: .bold)
        return label
    }()
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Asset.analytic.image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "empty_statistic_placeholder")
        label.textColor = Asset.blackDay.color
        label.font = UIFont.systemFont(ofSize: UIConstants.mainSubtitleFontSize, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let cardsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = UIConstants.statisticStackSpacing
        return stack
    }()
    
    private let bestPeriodCard = StatisticCardView(title: String(localized: "statistic_best_period"))
    private let idealDaysCard = StatisticCardView(title: String(localized: "statistic_ideal_days"))
    private let completedTrackersCard = StatisticCardView(title: String(localized: "statistic_completed_trackers"))
    private let averageValueCard = StatisticCardView(title: String(localized: "statistic_average_value"))
    
    // MARK: - Initializers
    init(
        trackerRecordStore: TrackerRecordStore,
        trackerCategoryStore: TrackerCategoryStore
    ) {
        self.trackerRecordStore = trackerRecordStore
        self.trackerCategoryStore = trackerCategoryStore
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.whiteDay.color
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatistics()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderLabel)
        view.addSubview(cardsStackView)
        
        [bestPeriodCard, idealDaysCard, completedTrackersCard, averageValueCard].forEach {
            cardsStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.mainTitleTopOffset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingPadding),
            
            placeholderImageView.widthAnchor.constraint(equalToConstant: UIConstants.categoryPlaceholderImageSize),
            placeholderImageView.heightAnchor.constraint(equalToConstant: UIConstants.categoryPlaceholderImageSize),
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.emptyStateImageCenterYOffset),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: UIConstants.categoryPlaceholderLabelTopOffset),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cardsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIConstants.statisticCardsTopOffset),
            cardsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingPadding),
            cardsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.trailingPadding)
        ])
    }
    
    private func updateStatistics() {
        let records = trackerRecordStore.records
        let hasRecords = !records.isEmpty
        
        placeholderImageView.isHidden = hasRecords
        placeholderLabel.isHidden = hasRecords
        cardsStackView.isHidden = !hasRecords
        
        guard hasRecords else { return }
        
        let completedCount = records.count
        let bestPeriod = calculateBestPeriod(records: records)
        let idealDays = calculateIdealDays(records: records)
        let averageValue = calculateAverageValue(records: records)
        
        bestPeriodCard.configure(value: bestPeriod)
        idealDaysCard.configure(value: idealDays)
        completedTrackersCard.configure(value: completedCount)
        averageValueCard.configure(value: averageValue)
    }
    
    private func calculateBestPeriod(records: [TrackerRecord]) -> Int {
        let calendar = Calendar.current
        let recordsByTracker = Dictionary(grouping: records, by: \.id)
        var maxStreak = 0
        
        for (_, trackerRecords) in recordsByTracker {
            let uniqueDays = Set(trackerRecords.map { calendar.startOfDay(for: $0.date) }).sorted()
            var currentStreak = 0
            var previousDay: Date?
            
            for day in uniqueDays {
                if let prev = previousDay,
                   let nextExpectedDay = calendar.date(byAdding: .day, value: 1, to: prev),
                   calendar.isDate(day, inSameDayAs: nextExpectedDay) {
                    currentStreak += 1
                } else {
                    currentStreak = 1
                }
                maxStreak = max(maxStreak, currentStreak)
                previousDay = day
            }
        }
        return maxStreak
    }
    
    private func calculateIdealDays(records: [TrackerRecord]) -> Int {
        let calendar = Calendar.current
        let allTrackers = trackerCategoryStore.categories.flatMap(\.trackers)
        guard !allTrackers.isEmpty else { return 0 }
        
        let recordsByDay = Dictionary(grouping: records) { calendar.startOfDay(for: $0.date) }
        var idealDaysCount = 0
        
        for (day, dayRecords) in recordsByDay {
            guard let weekDay = WeekDay(date: day) else { continue }
            let scheduledTrackers = allTrackers.filter { $0.schedule.contains(weekDay) }
            guard !scheduledTrackers.isEmpty else { continue }
            
            let completedIds = Set(dayRecords.map(\.id))
            let scheduledIds = Set(scheduledTrackers.map(\.id))
            
            if scheduledIds.isSubset(of: completedIds) {
                idealDaysCount += 1
            }
        }
        return idealDaysCount
    }
    
    private func calculateAverageValue(records: [TrackerRecord]) -> Int {
       
        let calendar = Calendar.current
        let uniqueDaysCount = Set(records.map { calendar.startOfDay(for: $0.date) }).count
        guard uniqueDaysCount > 0 else { return 0 }
        return Int(round(Double(records.count) / Double(uniqueDaysCount)))
    }
}
