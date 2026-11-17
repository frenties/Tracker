import UIKit

// MARK: - UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        cell.titleLabel.text = tracker.name
        cell.emojiLabel.text = tracker.emoji
        cell.cardColor = tracker.color
        cell.pinImageView.isHidden = !tracker.isPinned
        
        let isCompletedToday = isTrackerCompletedToday(tracker.id)
        
        if isCompletedToday {
            cell.completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            cell.completeButton.alpha = UIConstants.completedButtonAlpha
        } else {
            cell.completeButton.setImage(UIImage(systemName: "plus"), for: .normal)
            cell.completeButton.alpha = UIConstants.defaultButtonAlpha
        }
        
        let daysCount = completedDaysCount(for: tracker.id)
        cell.daysLabel.text = formatDaysString(for: daysCount)
        
        cell.buttonAction = { [weak self] in
            guard let self else { return }
            
            AnalyticsService.shared.report(event: .click, screen: .main, item: .track)
            
            if Calendar.current.compare(self.currentDate, to: Date(), toGranularity: .day) == .orderedDescending {
                let alert = UIAlertController(
                    title: String(localized: "future_date_alert_title"),
                    message: String(localized: "future_date_alert_message"),
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: String(localized: "ok_button"), style: .default))
                self.present(alert, animated: true)
                return
            }
            
            self.toggleTrackerCompletion(for: tracker.id, at: indexPath)
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

// MARK: - UICollectionViewDelegate
extension TrackerViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { [weak self] _ in
            guard let self else { return UIMenu() }
            
            let pinTitle = tracker.isPinned
            ? String(localized: "context_unpin")
            : String(localized: "context_pin")
            
            let pinAction = UIAction(title: pinTitle) { _ in
                self.togglePin(for: tracker.id)
            }
            
            let editAction = UIAction(title: String(localized: "context_edit")) { _ in
                AnalyticsService.shared.report(event: .click, screen: .main, item: .edit)
                self.presentEditTracker(tracker)
            }
            
            let deleteAction = UIAction(
                title: String(localized: "context_delete"),
                attributes: .destructive
            ) { _ in
                AnalyticsService.shared.report(event: .click, screen: .main, item: .delete)
                self.showDeleteConfirmation(for: tracker)
            }
            
            return UIMenu(children: [pinAction, editAction, deleteAction])
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else {
            return nil
        }
        return UITargetedPreview(view: cell.cardView)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - UIConstants.trackersSectionRightInset - UIConstants.trackersInterItemSpacing
        let width = availableWidth / UIConstants.trackersColumnsCount
        return CGSize(width: width, height: UIConstants.trackersCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        UIConstants.trackersInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(
            top: UIConstants.trackersSectionTopInset,
            left: .zero,
            bottom: UIConstants.trackersSectionBottomInset,
            right: UIConstants.trackersSectionRightInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: UIConstants.trackersHeaderHeight)
    }
}

// MARK: - Private Methods
extension TrackerViewController {
    
    private func formatDaysString(for count: Int) -> String {
        String.localizedStringWithFormat(
            NSLocalizedString("days_count", comment: "Number of completed days"),
            count
        )
    }
    
    private func showDeleteConfirmation(for tracker: Tracker) {
        let alert = UIAlertController(
            title: nil,
            message: String(localized: "delete_tracker_confirmation"),
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: String(localized: "context_delete"), style: .destructive) { [weak self] _ in
            self?.deleteTracker(tracker)
        })
        alert.addAction(UIAlertAction(title: String(localized: "cancel_button"), style: .cancel))
        present(alert, animated: true)
    }
}
