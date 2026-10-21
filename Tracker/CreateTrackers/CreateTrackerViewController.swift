import Foundation
import UIKit

// MARK: - CreateTrackerViewControllerDelegate Protocol
protocol CreateTrackerViewControllerDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, toCategory title: String)
}

final class CreateTrackerViewController: UIViewController {
    
    // MARK: - Properties
    var selectedDays: [WeekDay] = []
    var optionsTableViewTopConstraint: NSLayoutConstraint?
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(resource: .blackDay)
        label.textAlignment = .center
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = UIColor(resource: .backgroundDay)
        textField.layer.cornerRadius = UIConstants.cornerRadius
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: UIConstants.textFieldPadding, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    let optionsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(resource: .backgroundDay)
        tableView.layer.cornerRadius = UIConstants.cornerRadius
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(UIColor(resource: .redYP), for: .normal)
        button.layer.cornerRadius = UIConstants.cornerRadius
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(resource: .redYP).cgColor
        button.backgroundColor = .clear
        return button
    }()
    
    let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = UIConstants.cornerRadius
        button.backgroundColor = .lightGray
        return button
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ограничение 38 символов"
        label.textColor = UIColor(resource: .redYP)
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupTableView()
    }
    
    // MARK: - Setup UI & Constraints
    private func setupViews() {
        addSubviews()
        setupActions()
        setupMainConstraints()
    }
    
    private func addSubviews() {
        [titleLabel, nameTextField, optionsTableView, cancelButton, createButton, errorLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        nameTextField.delegate = self
    }
    
    private func setupMainConstraints() {
        optionsTableViewTopConstraint = optionsTableView.topAnchor.constraint(
            equalTo: nameTextField.bottomAnchor,
            constant: UIConstants.tableViewTopDefaultOffset
        )
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.titleTopOffset),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: UIConstants.titleWidth),
            titleLabel.heightAnchor.constraint(equalToConstant: UIConstants.titleHeight),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIConstants.textFieldTopOffset),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingPadding),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.trailingPadding),
            nameTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight),
            
            errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: UIConstants.errorLabelTopOffset),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingPadding),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.trailingPadding),
            errorLabel.heightAnchor.constraint(equalToConstant: UIConstants.errorLabelHeight),
            
            optionsTableViewTopConstraint!,
            optionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingPadding),
            optionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.trailingPadding),
            optionsTableView.heightAnchor.constraint(equalToConstant: UIConstants.tableViewHeight),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: UIConstants.buttonBottomOffset),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.buttonLeadingPadding),
            cancelButton.widthAnchor.constraint(equalToConstant: UIConstants.buttonWidth),
            cancelButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            
            createButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.buttonTrailingPadding),
            createButton.widthAnchor.constraint(equalToConstant: UIConstants.buttonWidth),
            createButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight)
        ])
    }
    
    private func setupTableView() {
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        
        optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: UIConstants.cellIdentifier)
    }
    
    // MARK: - Actions
    @objc private func createButtonTapped() {
        guard let trackerName = nameTextField.text, !trackerName.isEmpty else { return }
        let newTracker = Tracker(id: UUID(), name: trackerName, color: .greenYP, emoji: "", schedule: selectedDays)
        delegate?.didCreateTracker(newTracker, toCategory: "Важное")
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}
