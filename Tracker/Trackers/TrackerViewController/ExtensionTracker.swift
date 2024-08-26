//
//  ExtensionTracker.swift
//  Tracker
//
//  Created by Вадим on 15.08.2024.
//

import UIKit

// MARK: - TrackerTypeSelectionDelegate

extension TrackerViewController: TrackerTypeSelectionDelegate, TrackerCreationDelegate {
    func didCreateTracker(
        _ tracker: Tracker,
        inCategory category: String
    ) {
        dataManager.addNewTracker(to: category, tracker: tracker)
        updateTrackersView()
    }
    
    func didSelectTrackerType(_ type: TrackerType) {
        dismiss(animated: true) {
            let createTrackerVC = TrackerCreationViewController()
            createTrackerVC.trackerType = type
            createTrackerVC.delegate = self
            self.present(createTrackerVC, animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension TrackerViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sectionCount = dataManager.categories.count
//        let sectionCount = dataManager.fetchAllCategories().count
        return sectionCount
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            let category = dataManager.categories[section]
            let trackers = category.trackers.filter {
//          let category = dataManager.fetchAllCategories()[section]
//          let trackers = (category.trackers?.allObjects as? [TrackerCoreData])?.filter {
                dataManager.shouldDisplayTracker($0, forDate: selectedDate, dateFormatter: dateFormatter)
            }
//          } ?? []
            return trackers.count
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "TrackerCell",
                for: indexPath) as? TrackerCell else {
                return UICollectionViewCell()
            }
//          let category = dataManager.fetchAllCategories()[indexPath.section]
//          let trackers = (category.trackers?.allObjects as? [TrackerCoreData])?.filter {
            let category = dataManager.categories[indexPath.section]
            let trackers = category.trackers.filter {
                dataManager.shouldDisplayTracker($0, forDate: selectedDate, dateFormatter: dateFormatter)
            }
//          } ?? []
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "TrackerSectionHeader",
                    for: indexPath
                ) as? TrackerSectionHeader else {
                    return UICollectionReusableView()
                }
//              let category = dataManager.fetchAllCategories()[indexPath.section]
                let category = dataManager.categories[indexPath.section]
                headerView.titleLabel.text = category.title
                return headerView
            }
            return UICollectionReusableView()
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 30)
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
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
