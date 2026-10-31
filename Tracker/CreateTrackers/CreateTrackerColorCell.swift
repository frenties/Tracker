import Foundation
import UIKit

final class CreateTrackerColorCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        contentView.addSubview(colorView)
     
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        layer.cornerRadius = 12
        layer.borderWidth = 3
        layer.borderColor = UIColor.clear.cgColor
    }
    
    // MARK: - Public Methods
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
    }
    
    func setSelection(isSelected: Bool, with color: UIColor) {
        layer.borderColor = isSelected ? color.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
    }
}
