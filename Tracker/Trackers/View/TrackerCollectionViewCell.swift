import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    static let identifier = "TrackerCollectionViewCell"
    
    var buttonAction: (() -> Void)?
    
    // MARK: - Public Properties
    var cardColor: UIColor? {
        didSet {
            cardView.backgroundColor = cardColor
            completeButton.backgroundColor = cardColor
        }
    }
    
    // MARK: - UI Elements
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = UIConstants.cardCornerRadius
        view.layer.borderWidth = UIConstants.cardBorderWidth
        view.layer.borderColor = Asset.borderColor.color.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let emojiBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(UIConstants.emojiBackgroundAlpha)
        view.layer.cornerRadius = UIConstants.emojiBackgroundCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIConstants.emojiFontSize)
        label.textAlignment = .center
        return label
    }()
    
    let pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "pin.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: UIConstants.cardTextFontSize, weight: .medium)
        label.numberOfLines = UIConstants.titleNumberOfLines
        return label
    }()
    
    let daysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Asset.blackDay.color
        label.font = UIFont.systemFont(ofSize: UIConstants.cardTextFontSize, weight: .medium)
        return label
    }()
    
    let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = UIConstants.completeButtonCornerRadius
        button.clipsToBounds = true
        button.tintColor = .white
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.cardColor = Asset.greenYP.color
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubview(emojiBackgroundView)
        emojiBackgroundView.addSubview(emojiLabel)
        cardView.addSubview(pinImageView)
        cardView.addSubview(titleLabel)
        
        contentView.addSubview(daysLabel)
        contentView.addSubview(completeButton)
        
        completeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: UIConstants.cardHeight),
            
            emojiBackgroundView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: UIConstants.cardContentPadding),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: UIConstants.cardContentPadding),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: UIConstants.emojiBackgroundSize),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: UIConstants.emojiBackgroundSize),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            
            pinImageView.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            pinImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -UIConstants.cardContentPadding),
            pinImageView.widthAnchor.constraint(equalToConstant: UIConstants.cardContentPadding),
            pinImageView.heightAnchor.constraint(equalToConstant: UIConstants.cardContentPadding),
            
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: UIConstants.cardContentPadding),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -UIConstants.cardContentPadding),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -UIConstants.cardContentPadding),
            
            completeButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: UIConstants.completeButtonTopOffset),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.cardContentPadding),
            completeButton.widthAnchor.constraint(equalToConstant: UIConstants.completeButtonSize),
            completeButton.heightAnchor.constraint(equalToConstant: UIConstants.completeButtonSize),
            
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.cardContentPadding),
            daysLabel.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        buttonAction?()
    }
}
