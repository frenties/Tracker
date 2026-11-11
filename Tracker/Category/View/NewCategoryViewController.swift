import UIKit

final class NewCategoryViewController: UIViewController {
    
    // MARK: - Properties
    var onCategoryCreated: ((String) -> Void)?
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = UIConstants.Strings.newCategoryTitle
        label.font = UIFont.systemFont(ofSize: UIConstants.categoryTitleFontSize, weight: .medium)
        label.textColor = UIColor(resource: .blackDay)
        label.textAlignment = .center
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = UIConstants.Strings.categoryNamePlaceholder
        textField.backgroundColor = UIColor(resource: .backgroundDay)
        textField.layer.cornerRadius = UIConstants.cornerRadius
        textField.font = UIFont.systemFont(ofSize: UIConstants.categoryTextFieldFontSize, weight: .regular)
        textField.clearButtonMode = .whileEditing
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: UIConstants.textFieldPadding, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(UIConstants.Strings.doneButtonTitle, for: .normal)
        button.setTitleColor(UIColor(resource: .whiteDay), for: .normal)
        button.backgroundColor = UIColor(resource: .grayYP)
        button.layer.cornerRadius = UIConstants.cornerRadius
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.categoryButtonFontSize, weight: .medium)
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .whiteDay)
        
        setupUI()
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange() {
        let text = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let isValid = !text.isEmpty
        
        doneButton.isEnabled = isValid
        doneButton.backgroundColor = isValid ? UIColor(resource: .blackDay) : UIColor(resource: .grayYP)
    }
    
    @objc private func didTapDoneButton() {
        guard let categoryName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !categoryName.isEmpty else { return }
        
        onCategoryCreated?(categoryName)
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.titleTopOffset),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIConstants.textFieldTopOffset),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingPadding),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.trailingPadding),
            nameTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.buttonLeadingPadding),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.buttonTrailingPadding),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: UIConstants.categoryButtonBottomOffset),
            doneButton.heightAnchor.constraint(equalToConstant: UIConstants.categoryButtonHeight)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
