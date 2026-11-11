import UIKit

final class CreateTrackerColorCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = UIConstants.colorViewCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: UIConstants.colorViewSize),
            colorView.heightAnchor.constraint(equalToConstant: UIConstants.colorViewSize)
        ])
        
        layer.cornerRadius = UIConstants.colorCellCornerRadius
        layer.borderWidth = UIConstants.colorCellBorderWidth
        layer.borderColor = UIColor.clear.cgColor
    }
    
    // MARK: - Public Methods
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
    }
    
    func setSelection(isSelected: Bool, with color: UIColor) {
        layer.borderColor = isSelected
        ? color.withAlphaComponent(UIConstants.colorCellSelectionAlpha).cgColor
        : UIColor.clear.cgColor
    }
}
