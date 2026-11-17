import UIKit

// MARK: - ScheduleViewControllerDelegate Protocol
protocol ScheduleViewControllerDelegate: AnyObject {
    func didUpdateSchedule(_ selectedDays: [WeekDay])
}

final class ScheduleViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: ScheduleViewControllerDelegate?
    private let weekDays: [WeekDay] = WeekDay.allCases
    var currentSelectedDays: Set<WeekDay> = []
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = UIConstants.Strings.schedule
        label.textColor = Asset.blackDay.color
        label.font = UIFont.systemFont(ofSize: UIConstants.categoryTitleFontSize, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let scheduleTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Asset.backgroundDay.color
        tableView.layer.cornerRadius = UIConstants.cornerRadius
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: UIConstants.leadingPadding,
            bottom: 0,
            right: UIConstants.leadingPadding
        )
        return tableView
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(UIConstants.Strings.doneButtonTitle, for: .normal)
        button.setTitleColor(Asset.whiteDay.color, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.categoryButtonFontSize, weight: .medium)
        button.layer.cornerRadius = UIConstants.cornerRadius
        button.backgroundColor = Asset.blackDay.color
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupTableView()
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(scheduleTableView)
        view.addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.titleTopOffset),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: UIConstants.titleHeight),
            
            scheduleTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingPadding),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.trailingPadding),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 525),
            
            doneButton.topAnchor.constraint(equalTo: scheduleTableView.bottomAnchor, constant: 40),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.buttonLeadingPadding),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.buttonTrailingPadding),
            doneButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight)
        ])
    }
    
    private func setupTableView() {
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        scheduleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "WeekDayCell")
    }
    
    // MARK: - Actions
    @objc private func doneButtonTapped() {
        let sortedDays = currentSelectedDays.sorted { $0.rawValue < $1.rawValue }
        delegate?.didUpdateSchedule(sortedDays)
        dismiss(animated: true)
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        let day = weekDays[sender.tag]
        if sender.isOn {
            currentSelectedDays.insert(day)
        } else {
            currentSelectedDays.remove(day)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekDayCell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let day = weekDays[indexPath.row]
        
        cell.textLabel?.text = day.localizedName
        cell.textLabel?.font = UIFont.systemFont(ofSize: UIConstants.categoryTextFieldFontSize, weight: .regular)
        cell.textLabel?.textColor = Asset.blackDay.color
        
        let switchView = UISwitch()
        switchView.onTintColor = Asset.blueYP.color
        switchView.tag = indexPath.row
        switchView.isOn = currentSelectedDays.contains(day)
        switchView.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        cell.accessoryView = switchView
        
        if indexPath.row == weekDays.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: UIConstants.leadingPadding,
                bottom: 0,
                right: UIConstants.leadingPadding
            )
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.menuCellHeight
    }
}
