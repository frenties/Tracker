import UIKit

final class OnboardingPageViewController: UIViewController {
    
    // MARK: - Properties
    var onConfirmButtonTapped: (() -> Void)?
    private let imageName: String
    private let titleText: String
    
    // MARK: - UI Elements
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blackDay
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.whiteDay, for: .normal)
        button.layer.cornerRadius = UIConstants.cornerRadius
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers
    init(imageName: String, titleText: String) {
        self.imageName = imageName
        self.titleText = titleText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        backgroundImageView.image = UIImage(named: imageName)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = UIConstants.onboardingTitleLineHeight
        paragraphStyle.maximumLineHeight = UIConstants.onboardingTitleLineHeight
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: UIConstants.onboardingTitleFontSize, weight: .bold),
            .foregroundColor: UIColor.blackDay,
            .paragraphStyle: paragraphStyle
        ]
        
        titleLabel.attributedText = NSAttributedString(string: titleText, attributes: attributes)
        
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.buttonLeadingPadding),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.buttonTrailingPadding),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: UIConstants.onboardingButtonBottomOffset),
            confirmButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.onboardingTitleLeadingTrailingPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.onboardingTitleLeadingTrailingPadding),
            titleLabel.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: UIConstants.onboardingTitleBottomOffset)
        ])
    }
    
    @objc private func buttonTapped() {
        onConfirmButtonTapped?()
    }
}
