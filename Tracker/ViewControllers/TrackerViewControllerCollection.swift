import UIKit

// MARK: - UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        cell.titleLabel.text = tracker.name
        cell.emojiLabel.text = tracker.emoji
        cell.cardColor = tracker.color
        
        var completedTodayIds: Set<UUID> = []
        for record in completedTrackers {
            if Calendar.current.isDate(record.date, inSameDayAs: self.currentDate) {
                completedTodayIds.insert(record.id)
            }
        }
        
        let isCompletedToday = completedTodayIds.contains(tracker.id)
        
        if isCompletedToday {
            cell.completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            cell.completeButton.alpha = 0.5
        } else {
            cell.completeButton.setImage(UIImage(systemName: "plus"), for: .normal)
            cell.completeButton.alpha = 1.0
        }
        
        let completedDaysCount = completedTrackers.filter { $0.id == tracker.id }.count
        cell.daysLabel.text = formatDaysString(for: completedDaysCount)
        
        cell.buttonAction = { [weak self] in
            guard let self else { return }
            
            if Calendar.current.compare(self.currentDate, to: Date(), toGranularity: .day) == .orderedDescending {
                let alert = UIAlertController(
                    title: "Нельзя отмечать трекеры в будущем",
                    message: "Будущее еще не наступило!",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ок", style: .default))
                self.present(alert, animated: true)
                return
            }
            
            if isCompletedToday {
                self.completedTrackers.removeAll { record in
                    record.id == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: self.currentDate)
                }
            } else {
                let newRecord = TrackerRecord(id: tracker.id, date: self.currentDate)
                self.completedTrackers.append(newRecord)
            }
            
            collectionView.reloadItems(at: [indexPath])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerHeaderView.identifier,
                for: indexPath
              ) as? TrackerHeaderView else {
            return UICollectionReusableView()
        }
        header.titleLabel.text = visibleCategories[indexPath.section].title
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 16 - 9
        let width = availableWidth / 2
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}

// MARK: - Private Methods
extension TrackerViewController {
    
    private func formatDaysString(for count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        if remainder100 >= 11 && remainder100 <= 19 { return "\(count) дней" }
        switch remainder10 {
        case 1: return "\(count) день"
        case 2, 3, 4: return "\(count) дня"
        default: return "\(count) дней"
        }
    }
}

