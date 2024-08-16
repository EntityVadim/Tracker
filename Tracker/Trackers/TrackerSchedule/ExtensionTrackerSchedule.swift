//
//  ExtensionTrackerSchedule.swift
//  Tracker
//
//  Created by Вадим on 15.08.2024.
//

import UIKit

// MARK: - UITableViewDelegate & UITableViewDataSource

extension TrackerScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return WeekDay.allCases.count
        }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let day = WeekDay.allCases[indexPath.row]
            cell.textLabel?.text = day.rawValue
            let switchView = UISwitch()
            switchView.isOn = selectedDays.contains(day)
            switchView.addTarget(self, action: #selector(switchChanged(sender:)), for: .valueChanged)
            switchView.onTintColor = UIColor.ypBlue
            cell.backgroundColor = UIColor.ypBackgroundDay
            cell.accessoryView = switchView
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            return cell
        }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
    
    @objc func switchChanged(sender: UISwitch) {
        guard let cell = sender.superview as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let day = WeekDay.allCases[indexPath.row]
        if sender.isOn {
            selectedDays.append(day)
        } else {
            if let index = selectedDays.firstIndex(of: day) {
                selectedDays.remove(at: index)
            }
        }
    }
}
