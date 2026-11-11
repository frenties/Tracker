import UIKit

final class CategoryViewController: UIViewController {
    
    // MARK: - Properties
    var selectedCategoryTitle: String?
    private let viewModel: CategoryListViewModel
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = UIConstants.cornerRadius
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = UIColor(resource: .backgroundDay)
        tableView.rowHeight = UIConstants.menuCellHeight
        return tableView
    }()
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .starBackground))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = UIConstants.categoryPlaceholderNumberOfLines
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = UIConstants.categoryPlaceholderLineSpacing
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: UIConstants.categoryPlaceholderFontSize, weight: .medium),
            .foregroundColor: UIColor(resource: .blackDay),
            .paragraphStyle: paragraphStyle
        ]
        
        label.attributedText = NSAttributedString(
            string: UIConstants.Strings.categoryPlaceholder,
            attributes: attributes
        )
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(UIConstants.Strings.addCategoryButtonTitle, for: .normal)
        button.setTitleColor(UIColor(resource: .whiteDay), for: .normal)
        button.backgroundColor = UIColor(resource: .blackDay)
        button.layer.cornerRadius = UIConstants.cornerRadius
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.categoryButtonFontSize, weight: .medium)
        button.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    init(viewModel: CategoryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .whiteDay)
        title = UIConstants.Strings.category
        
        setupUI()
        bindViewModel()
        viewModel.fetchCategories()
    }
    
    // MARK: - Actions
    @objc private func didTapAddCategoryButton() {
        let newCategoryVC = NewCategoryViewController()
        newCategoryVC.onCategoryCreated = { [weak self] categoryTitle in
            self?.viewModel.addNewCategory(named: categoryTitle)
        }
        present(newCategoryVC, animated: true)
    }
    
    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.categoriesBinding = { [weak self] categories in
            guard let self else { return }
            self.tableView.reloadData()
            
            let isCategoriesEmpty = categories.isEmpty
            self.tableView.isHidden = isCategoriesEmpty
            self.placeholderImageView.isHidden = !isCategoriesEmpty
            self.placeholderLabel.isHidden = !isCategoriesEmpty
            
            self.tableViewHeightConstraint?.constant = CGFloat(categories.count) * UIConstants.menuCellHeight
        }
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderLabel)
        view.addSubview(addCategoryButton)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        
        let heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.priority = .defaultHigh
        self.tableViewHeightConstraint = heightConstraint
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.tableViewTopDefaultOffset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingPadding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.trailingPadding),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: addCategoryButton.topAnchor, constant: -UIConstants.tableViewTopDefaultOffset),
            heightConstraint,
            
            placeholderImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -UIConstants.categoryPlaceholderImageSize),
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: UIConstants.categoryPlaceholderImageSize),
            placeholderImageView.heightAnchor.constraint(equalToConstant: UIConstants.categoryPlaceholderImageSize),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: UIConstants.categoryPlaceholderLabelTopOffset),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingPadding),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.trailingPadding),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.buttonLeadingPadding),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.buttonTrailingPadding),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: UIConstants.categoryButtonBottomOffset),
            addCategoryButton.heightAnchor.constraint(equalToConstant: UIConstants.categoryButtonHeight)
        ])
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.identifier,
            for: indexPath
        ) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        let categoryTitle = viewModel.categories[indexPath.row].title
        cell.configure(with: categoryTitle, isSelected: categoryTitle == selectedCategoryTitle)
        
        if indexPath.row == viewModel.categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.leadingPadding, bottom: 0, right: UIConstants.leadingPadding)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedTitle = viewModel.categories[indexPath.row].title
        selectedCategoryTitle = selectedTitle
        tableView.reloadData()
        
        viewModel.onCategorySelected?(selectedTitle)
        
        if let navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteCategory(at: indexPath.row)
        }
    }
}
