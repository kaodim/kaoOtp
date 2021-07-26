//
//  KaoTableViewController.swift
//  KaoDesign
//
//  Created by Augustius on 14/01/2020.
//

import Foundation

open class KaoTableViewController: KaoBaseViewController, UITableViewDataSource, UITableViewDelegate {
    public var items: [TableViewVMProtocol] = []

    // MARK: - Notification Handle
    open func dropError(_ message: String) {
        self.dropErrorMessage(message)
    }

    open func dropSuccess(_ message: String) {
        self.dropSuccessMessage(message)
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = items[section]
        return item.rowCount
    }

    open func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        let cell = item.tableView(tableView, cellForRowAt: indexPath)
        cell.layoutIfNeeded()
        return cell
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section]
        item.tableView(tableView, didSelectRowAt: indexPath)
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = items[section]
        return item.tableView(tableView, viewForHeaderInSection: section)
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let item = items[section]
        return item.tableView(tableView, heightForHeaderInSection: section)
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let item = items[section]
        return item.tableView(tableView, viewForFooterInSection: section)
    }

    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let item = items[section]
        return item.tableView(tableView, heightForFooterInSection: section)
    }

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
}
