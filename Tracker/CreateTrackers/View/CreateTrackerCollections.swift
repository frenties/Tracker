import Foundation
import UIKit

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension CreateTrackerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? UIConstants.emojis.count : UIConstants.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.emojiCellIdentifier, for: indexPath) as? CreateTrackerEmojiCell else {
                return UICollectionViewCell()
            }
            cell.emojiLabel.text = UIConstants.emojis[indexPath.row]
            cell.setSelected(indexPath.row == selectedEmojiIndex)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.colorCellIdentifier, for: indexPath) as? CreateTrackerColorCell else {
                return UICollectionViewCell()
            }
            let color = UIConstants.colors[indexPath.row]
            cell.configure(with: color)
            cell.setSelection(isSelected: indexPath.row == selectedColorIndex, with: color)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UIConstants.headerIdentifier, for: indexPath) as? CreateTrackerHeaderView else {
            return UICollectionReusableView()
        }
        header.titleLabel.text = indexPath.section == 0 ? UIConstants.Strings.emojiSectionTitle : UIConstants.Strings.colorSectionTitle
        return header
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 34)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        } else {
            return UIEdgeInsets(top: 16, left: 16, bottom: 12, right: 16)
        }
    }
    
    // MARK: - Selection Handling
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedEmojiIndex = indexPath.row
        } else {
            selectedColorIndex = indexPath.row
        }
        collectionView.reloadSections(IndexSet(integer: indexPath.section))
        validateForm()
    }
}

