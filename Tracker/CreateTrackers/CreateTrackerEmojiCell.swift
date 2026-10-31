import Foundation
import UIKit

final class CreateTrackerEmojiCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        return label
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
        contentView.addSubview(emojiLabel)
        
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Selection State
    func setSelected(_ isSelected: Bool) {
        contentView.backgroundColor = isSelected ? UIColor(resource: .grayYP) : .clear
    }
    
    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }
}

