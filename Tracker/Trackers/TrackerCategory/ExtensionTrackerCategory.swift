//
//  ExtensionTrackerCategory.swift
//  Tracker
//
//  Created by Вадим on 15.08.2024.
//

import UIKit

// MARK: - UITableViewDataSource

extension TrackerCategoryViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return categories.count
        }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "CustomCategoryCell",
                for: indexPath) as? TrackerCategoryCell else {
                return UITableViewCell()
            }
            let category = categories[indexPath.row]
            let isSelected = category == selectedCategory
            cell.configure(with: category, isSelected: isSelected)
            cell.contentView.backgroundColor = .ypLightGray
            return cell
        }
}

// MARK: - UITableViewDelegate

extension TrackerCategoryViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
            if indexPath.row == 0 && categories.count == 1 {
                cell.contentView.layer.cornerRadius = 16
                cell.contentView.layer.maskedCorners = [
                    .layerMinXMinYCorner,
                    .layerMaxXMinYCorner,
                    .layerMinXMaxYCorner,
                    .layerMaxXMaxYCorner]
            } else if indexPath.row == 0 {
                cell.contentView.layer.cornerRadius = 16
                cell.contentView.layer.maskedCorners = [
                    .layerMinXMinYCorner,
                    .layerMaxXMinYCorner]
            } else if indexPath.row == categories.count - 1 {
                cell.contentView.layer.cornerRadius = 16
                cell.contentView.layer.maskedCorners = [
                    .layerMinXMaxYCorner,
                    .layerMaxXMaxYCorner]
            } else {
                cell.contentView.layer.cornerRadius = 0
            }
            cell.contentView.layer.masksToBounds = true
        }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let category = categories[indexPath.row]
        if category == selectedCategory {
            selectedCategory = nil
        } else {
            selectedCategory = category
        }
        tableView.reloadData()
    }
}
