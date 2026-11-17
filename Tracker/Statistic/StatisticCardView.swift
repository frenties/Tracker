import UIKit

final class StatisticCardView: UIView {
    
    // MARK: - UI Elements
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIConstants.statisticValueFontSize, weight: .bold)
        label.textColor = Asset.blackDay.color
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIConstants.statisticDescriptionFontSize, weight: .medium)
        label.textColor = Asset.blackDay.color
        return label
    }()
    
    // MARK: - Initializers
    init(title: String) {
        super.init(frame: .zero)
        descriptionLabel.text = title
        setupViews()
        setupGradientBorder()
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _) in
            self.updateGradientColors()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        let inset = UIConstants.statisticCardBorderWidth / UIConstants.statisticBorderInsetDivisor
        let borderRect = bounds.insetBy(dx: inset, dy: inset)
        shapeLayer.path = UIBezierPath(
            roundedRect: borderRect,
            cornerRadius: UIConstants.statisticCardCornerRadius
        ).cgPath
    }
    
    // MARK: - Public Methods
    func configure(value: Int) {
        valueLabel.text = "\(value)"
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Asset.whiteDay.color
        layer.cornerRadius = UIConstants.statisticCardCornerRadius
        
        addSubview(valueLabel)
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: UIConstants.statisticCardHeight),
            
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: UIConstants.statisticCardPadding),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.statisticCardPadding),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIConstants.statisticCardPadding),
            
            descriptionLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: UIConstants.statisticCardInnerSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.statisticCardPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIConstants.statisticCardPadding),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UIConstants.statisticCardPadding)
        ])
    }
    
    private func setupGradientBorder() {
        updateGradientColors()
        gradientLayer.startPoint = UIConstants.statisticGradientStartPoint
        gradientLayer.endPoint = UIConstants.statisticGradientEndPoint
        
        shapeLayer.lineWidth = UIConstants.statisticCardBorderWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        
        gradientLayer.mask = shapeLayer
        layer.addSublayer(gradientLayer)
    }
    
    private func updateGradientColors() {
        gradientLayer.colors = [
            Asset.redgradient.color.cgColor,
            Asset.greengradient.color.cgColor,
            Asset.bluegradient.color.cgColor
        ]
    }
}
