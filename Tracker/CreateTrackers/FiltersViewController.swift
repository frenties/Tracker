import UIKit

enum TrackerFilter: Int, CaseIterable {
    case all
    case today
    case completed
    case uncompleted
    
    var title: String {
        switch self {
        case .all: String(localized: "filter_all")
        case .today: String(localized: "filter_today")
        case .completed: String(localized: "filter_completed")
        case .uncompleted: String(localized: "filter_uncompleted")
        }
    }
    
    var isActiveFilter: Bool {
        self == .completed || self == .uncompleted
    }
}

final class FiltersViewController: UIViewController {
    
    // MARK: - Properties
    var onSelectFilter: ((TrackerFilter) -> Void)?
    private var selectedFilter: TrackerFilter
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "filters_button_title")
        label.font = UIFont.systemFont(ofSize: UIConstants.categoryTitleFontSize, weight: .medium)
        label.textColor = Asset.blackDay.color
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = Asset.backgroundDay.color
        table.layer.cornerRadius = UIConstants.cornerRadius
        table.isScrollEnabled = false
        table.separatorInset = UIEdgeInsets(
            top: 0,
            left: UIConstants.leadingPadding,
            bottom: 0,
            right: UIConstants.leadingPadding
        )
        return table
    }()
    
    // MARK: - Initializers
    init(selectedFilter: TrackerFilter) {
        self.selectedFilter = selectedFilter
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
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UIConstants.cellIdentifier)
        
        let tableHeight = CGFloat(TrackerFilter.allCases.count) * UIConstants.menuCellHeight
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.titleTopOffset),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIConstants.categoryTableViewTopOffset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingPadding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.trailingPadding),
            tableView.heightAnchor.constraint(equalToConstant: tableHeight)
        ])
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TrackerFilter.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIConstants.menuCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.cellIdentifier, for: indexPath)
        let filter = TrackerFilter.allCases[indexPath.row]
        
        cell.textLabel?.text = filter.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: UIConstants.categoryTextFieldFontSize, weight: .regular)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.tintColor = Asset.blueYP.color
        cell.accessoryType = (filter == selectedFilter && filter.isActiveFilter) ? .checkmark : .none
        
        if indexPath.row == TrackerFilter.allCases.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenFilter = TrackerFilter.allCases[indexPath.row]
        selectedFilter = chosenFilter
        tableView.reloadData()
        onSelectFilter?(chosenFilter)
        dismiss(animated: true)
    }
}
