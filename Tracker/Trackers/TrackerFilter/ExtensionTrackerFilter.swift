//
//  ExtensionTrackerFilter.swift
//  Tracker
//
//  Created by Вадим on 19.09.2024.
//

import UIKit

// MARK: - UITableViewDataSource

extension TrackerFilterViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return TrackerFilterType.allCases.count
        }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackerFilterViewController.cellIdentifier,
                for: indexPath) as! TrackerCategoryCell
            let option = TrackerFilterType.allCases[indexPath.row]
            let isSelected = indexPath.row == selectedFilter
            cell.backgroundColor = UIColor.ypBackgroundDay
            cell.configure(with: option.localizedString(), isSelected: isSelected)
            return cell
        }
}

// MARK: - UITableViewDelegate

extension TrackerFilterViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let previousSelectedFilter = selectedFilter
        selectedFilter = indexPath.row
        saveSelectedFilter(index: indexPath.row)
        var rowsToReload = [indexPath]
        if let previousIndex = previousSelectedFilter {
            let previousIndexPath = IndexPath(row: previousIndex, section: 0)
            rowsToReload.append(previousIndexPath)
        }
        tableView.reloadRows(at: rowsToReload, with: .none)
        let selectedFilterType = TrackerFilterType.allCases[indexPath.row]
        switchFilter(to: selectedFilterType)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == TrackerFilterType.allCases.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        if indexPath.row == 0 {
            tableView.separatorStyle = .singleLine
        }
    }
}
