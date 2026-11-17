import UIKit

// MARK: - CreateTrackerViewControllerDelegate Protocol
protocol CreateTrackerViewControllerDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, toCategory title: String)
    func didUpdateTracker(_ tracker: Tracker, toCategory title: String)
}

extension CreateTrackerViewControllerDelegate {
    func didUpdateTracker(_ tracker: Tracker, toCategory title: String) {}
}

final class CreateTrackerViewController: UIViewController {
    
    // MARK: - Properties
    var selectedDays: [WeekDay] = []
    var optionsTableViewTopConstraint: NSLayoutConstraint?
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    var selectedEmojiIndex: Int?
    var selectedColorIndex: Int?
    var selectedCategoryTitle: String = ""
    var trackerName: String = ""
    
    private var editingTracker: Tracker?
    private var completedDaysCount: Int = 0
    
    private var isEditMode: Bool {
        editingTracker != nil
    }
    
    // MARK: - UI Elements
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = UIConstants.Strings.newHabitTitle
        label.font = UIFont.systemFont(ofSize: UIConstants.categoryTitleFontSize, weight: .medium)
        label.textColor = Asset.blackDay.color
        label.textAlignment = .center
        return label
    }()
    
    private let daysCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIConstants.editDaysCountFontSize, weight: .bold)
        label.textColor = Asset.blackDay.color
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = UIConstants.Strings.trackerNamePlaceholder
        textField.backgroundColor = Asset.backgroundDay.color
        textField.layer.cornerRadius = UIConstants.cornerRadius
        textField.font = UIFont.systemFont(ofSize: UIConstants.categoryTextFieldFontSize, weight: .regular)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: UIConstants.textFieldPadding, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    let optionsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Asset.backgroundDay.color
        tableView.layer.cornerRadius = UIConstants.cornerRadius
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: UIConstants.leadingPadding,
            bottom: 0,
            right: UIConstants.leadingPadding
        )
        return tableView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.isScrollEnabled = false
        return collection
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(UIConstants.Strings.cancelButtonTitle, for: .normal)
        button.setTitleColor(Asset.redYP.color, for: .normal)
        button.layer.cornerRadius = UIConstants.cornerRadius
        button.layer.borderWidth = UIConstants.cancelButtonBorderWidth
        button.layer.borderColor = Asset.redYP.color.cgColor
        button.backgroundColor = .clear
        return button
    }()
    
    let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(UIConstants.Strings.createButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = UIConstants.cornerRadius
        button.backgroundColor = .lightGray
        button.isEnabled = false
        return button
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = UIConstants.Strings.nameLengthError
        label.textColor = Asset.redYP.color
        label.font = UIFont.systemFont(ofSize: UIConstants.categoryTextFieldFontSize, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - Initializers
    init(editingTracker: Tracker? = nil, categoryTitle: String = "", completedDaysCount: Int = 0) {
        self.editingTracker = editingTracker
        self.selectedCategoryTitle = categoryTitle
        self.completedDaysCount = completedDaysCount
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
        setupTableView()
        setupCollectionView()
        configureEditModeIfNeeded()
    }
    
    // MARK: - Setup UI & Constraints
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        addSubviews()
        setupActions()
        setupMainConstraints()
    }
    
    private func addSubviews() {
        [daysCountLabel, nameTextField, errorLabel, optionsTableView, collectionView, cancelButton, createButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        nameTextField.delegate = self
    }
    
    private func setupMainConstraints() {
        let topConstraint = optionsTableView.topAnchor.constraint(
            equalTo: nameTextField.bottomAnchor,
            constant: UIConstants.tableViewTopDefaultOffset
        )
        self.optionsTableViewTopConstraint = topConstraint
        
        let textFieldTopAnchor = isEditMode ? daysCountLabel.bottomAnchor : contentView.topAnchor
        let textFieldTopConstant: CGFloat = isEditMode ? UIConstants.editTextFieldTopOffset : .zero
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.titleTopOffset),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: UIConstants.titleHeight),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIConstants.scrollViewTopOffset),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            daysCountLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            daysCountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: textFieldTopAnchor, constant: textFieldTopConstant),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.leadingPadding),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UIConstants.trailingPadding),
            nameTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight),
            
            errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: UIConstants.errorLabelTopOffset),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.leadingPadding),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UIConstants.trailingPadding),
            errorLabel.heightAnchor.constraint(equalToConstant: UIConstants.errorLabelHeight),
            
            topConstraint,
            optionsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.leadingPadding),
            optionsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UIConstants.trailingPadding),
            optionsTableView.heightAnchor.constraint(equalToConstant: UIConstants.tableViewHeight),
            collectionView.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor, constant: UIConstants.collectionViewTopOffset),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.leadingPadding),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UIConstants.trailingPadding),
            collectionView.heightAnchor.constraint(equalToConstant: UIConstants.collectionViewHeight),
            cancelButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: UIConstants.buttonsTopOffset),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.buttonLeadingPadding),
            cancelButton.widthAnchor.constraint(equalToConstant: UIConstants.buttonWidth),
            cancelButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: UIConstants.buttonBottomOffset),
            createButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UIConstants.buttonTrailingPadding),
            createButton.widthAnchor.constraint(equalToConstant: UIConstants.buttonWidth),
            createButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight)
        ])
    }
    private func setupTableView() {
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: UIConstants.cellIdentifier)
    }
    private func setupCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
            layout.itemSize = CGSize(width: UIConstants.collectionItemSize, height: UIConstants.collectionItemSize)
            layout.minimumInteritemSpacing = UIConstants.collectionInterItemSpacing
            layout.minimumLineSpacing = UIConstants.collectionInterItemSpacing
            layout.sectionInset = UIEdgeInsets(
                top: UIConstants.emojiSectionTopInset,
                left: UIConstants.leadingPadding,
                bottom: UIConstants.collectionSectionBottomInset,
                right: UIConstants.leadingPadding
            )
            layout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: UIConstants.collectionHeaderHeight)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CreateTrackerEmojiCell.self, forCellWithReuseIdentifier: UIConstants.emojiCellIdentifier)
        collectionView.register(CreateTrackerColorCell.self, forCellWithReuseIdentifier: UIConstants.colorCellIdentifier)
        collectionView.register(
            CreateTrackerHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: UIConstants.headerIdentifier
        )
    }
    private func configureEditModeIfNeeded() {
        guard let tracker = editingTracker else { return }
        titleLabel.text = String(localized: "edit_habit_title")
        createButton.setTitle(String(localized: "save_button"), for: .normal)
        daysCountLabel.isHidden = false
        daysCountLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("days_count", comment: "Number of completed days"),
            completedDaysCount
        )
        trackerName = tracker.name
        nameTextField.text = tracker.name
        selectedDays = tracker.schedule
        selectedEmojiIndex = UIConstants.emojis.firstIndex(of: tracker.emoji)
        selectedColorIndex = UIConstants.colors.firstIndex(where: { $0.cgColor == tracker.color.cgColor })
        optionsTableView.reloadData()
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        if let emojiIndex = selectedEmojiIndex {
            let emojiIndexPath = IndexPath(item: emojiIndex, section: UIConstants.emojiSectionIndex)
            collectionView.selectItem(at: emojiIndexPath, animated: false, scrollPosition: [])
            collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: emojiIndexPath)
        }
        if let colorIndex = selectedColorIndex {
            let colorIndexPath = IndexPath(item: colorIndex, section: UIConstants.colorSectionIndex)
            collectionView.selectItem(at: colorIndexPath, animated: false, scrollPosition: [])
            collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: colorIndexPath)
        }
        validateForm()
    }
    func validateForm() {
        let isNameValid = !trackerName.isEmpty
        let isScheduleValid = !selectedDays.isEmpty
        let isEmojiValid = selectedEmojiIndex != nil
        let isColorValid = selectedColorIndex != nil
        let isCategoryValid = !selectedCategoryTitle.isEmpty
        let isFormValid = isNameValid && isScheduleValid && isEmojiValid && isColorValid && isCategoryValid
        createButton.isEnabled = isFormValid
        createButton.backgroundColor = isFormValid ? Asset.blackDay.color : .lightGray
    }
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    @objc private func createButtonTapped() {
        guard !trackerName.isEmpty,
              let emojiIndex = selectedEmojiIndex,
              let colorIndex = selectedColorIndex,
              !selectedCategoryTitle.isEmpty else { return }
        if let existingTracker = editingTracker {
            let updatedTracker = Tracker(
                id: existingTracker.id,
                name: trackerName,
                color: UIConstants.colors[colorIndex],
                emoji: UIConstants.emojis[emojiIndex],
                schedule: selectedDays,
                isPinned: existingTracker.isPinned
            )
            delegate?.didUpdateTracker(updatedTracker, toCategory: selectedCategoryTitle)
        } else {
            let newTracker = Tracker(
                id: UUID(),
                name: trackerName,
                color: UIConstants.colors[colorIndex],
                emoji: UIConstants.emojis[emojiIndex],
                schedule: selectedDays
            )
            delegate?.didCreateTracker(newTracker, toCategory: selectedCategoryTitle)
        }
        dismiss(animated: true)
    }
}
