//
//  ExtensionTracker.swift
//  Tracker
//
//  Created by Вадим on 15.08.2024.
//

import UIKit

// MARK: - TrackerTypeSelectionDelegate

extension TrackerViewController: TrackerTypeSelectionDelegate {
    func didSelectTrackerType(_ type: TrackerType) {
        dismiss(animated: true) {
            let createTrackerVC = TrackerCreationViewController()
            createTrackerVC.trackerType = type
            createTrackerVC.delegate = self
            self.present(createTrackerVC, animated: true, completion: nil)
        }
    }
}

// MARK: - TrackerCreationDelegate

extension TrackerViewController: TrackerCreationDelegate {
    func didCreateTracker(
        _ tracker: Tracker,
        inCategory category: String
    ) {
        dataManager.addNewTracker(to: category, tracker: tracker)
        updateTrackersView()
    }
}

// MARK: - UICollectionViewDataSource

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            let category = visibleCategories[section]
            let trackers = category.trackers.filter {
                dataManager.shouldDisplayTracker($0, forDate: selectedDate, dateFormatter: dateFormatter)
            }
            return trackers.count
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerCell.trackerCellIdentifier,
                for: indexPath) as? TrackerCell else {
                return UICollectionViewCell()
            }
            let category = visibleCategories[indexPath.section]
            let trackers = category.trackers.filter {
                dataManager.shouldDisplayTracker($0, forDate: selectedDate, dateFormatter: dateFormatter)
            }
            let tracker = trackers[indexPath.item]
            let completedTrackers = dataManager.completedTrackers.filter { $0.trackerId == tracker.id }
            cell.configure(
                with: tracker,
                completedTrackers: completedTrackers,
                dataManager: dataManager,
                date: dateFormatter.string(from: selectedDate))
            cell.delegate = self
            return cell
        }
}

// MARK: - UICollectionViewDelegate

extension TrackerViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: TrackerSectionHeader.trackerSectionHeaderIdentifier,
                    for: indexPath
                ) as? TrackerSectionHeader else {
                    return UICollectionReusableView()
                }
                let category = visibleCategories[indexPath.section]
                headerView.titleLabel.text = category.title
                return headerView
            }
            return UICollectionReusableView()
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint) -> UIContextMenuConfiguration? {
            let category = visibleCategories[indexPath.section]
            let trackers = category.trackers.filter {
                dataManager.shouldDisplayTracker($0, forDate: selectedDate, dateFormatter: dateFormatter)
            }
            let tracker = trackers[indexPath.item]
            let isPinned = dataManager.isTrackerPinned(tracker)
            let pinActionTitle = isPinned ?
            NSLocalizedString("Открепить", comment: "Unpin") :
            NSLocalizedString("Закрепить", comment: "Pin")
            let pinAction = UIAction(title: pinActionTitle, image: UIImage(systemName: "pin")) { _ in
                if isPinned {
                    self.dataManager.unpinTracker(tracker)
                } else {
                    self.dataManager.pinTracker(tracker)
                }
                self.updateTrackersView()
            }
            let editAction = UIAction(
                title: NSLocalizedString("Редактировать", comment: "Edit")) { _ in
                    self.presentEditTrackerViewController(for: tracker)
                }
            let deleteAction = UIAction(
                title: NSLocalizedString("Удалить", comment: "Delete"),
                attributes: .destructive) { _ in
                    self.handleDeleteTracker(tracker)
                }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                UIMenu(title: "", children: [pinAction, editAction, deleteAction])
            }
        }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 30)
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let cellWidth = collectionView.bounds.width / 2 - 20
            return CGSize(width: cellWidth, height: 148)
        }
}

// MARK: - TrackerCellDelegate

extension TrackerViewController: TrackerCellDelegate {
    func trackerCellDidToggleCompletion(
        _ cell: TrackerCell,
        for tracker: Tracker
    ) {
        updateTrackersView()
    }
}

// MARK: - UISearchBarDelegate

extension TrackerViewController: UISearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        updateTrackersView()
    }
}
