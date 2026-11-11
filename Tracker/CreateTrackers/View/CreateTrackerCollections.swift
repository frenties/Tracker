import UIKit

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension CreateTrackerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        UIConstants.trackerCollectionSectionsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == UIConstants.emojiSectionIndex ? UIConstants.emojis.count : UIConstants.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == UIConstants.emojiSectionIndex {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UIConstants.emojiCellIdentifier,
                for: indexPath
            ) as? CreateTrackerEmojiCell else {
                return UICollectionViewCell()
            }
            cell.emojiLabel.text = UIConstants.emojis[indexPath.row]
            cell.setSelected(indexPath.row == selectedEmojiIndex)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UIConstants.colorCellIdentifier,
                for: indexPath
            ) as? CreateTrackerColorCell else {
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
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: UIConstants.headerIdentifier,
                for: indexPath
              ) as? CreateTrackerHeaderView else {
            return UICollectionReusableView()
        }
        
        header.titleLabel.text = indexPath.section == UIConstants.emojiSectionIndex
            ? UIConstants.Strings.emojiSectionTitle
            : UIConstants.Strings.colorSectionTitle
        return header
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIConstants.collectionItemSize, height: UIConstants.collectionItemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        UIConstants.collectionInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        UIConstants.collectionLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: UIConstants.collectionHeaderHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let topInset = section == UIConstants.emojiSectionIndex
            ? UIConstants.emojiSectionTopInset
            : UIConstants.colorSectionTopInset
        
        return UIEdgeInsets(
            top: topInset,
            left: UIConstants.leadingPadding,
            bottom: UIConstants.collectionSectionBottomInset,
            right: UIConstants.leadingPadding
        )
    }
    
    // MARK: - Selection Handling
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == UIConstants.emojiSectionIndex {
            selectedEmojiIndex = indexPath.row
        } else {
            selectedColorIndex = indexPath.row
        }
        collectionView.reloadSections(IndexSet(integer: indexPath.section))
        validateForm()
    }
}
