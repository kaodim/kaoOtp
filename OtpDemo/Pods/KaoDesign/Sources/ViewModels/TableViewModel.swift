//
//  TableViewModel.swift
//  KaoDesign
//
//  Created by augustius cokroe on 14/03/2019.
//

import Foundation

 @objc public protocol BaseViewModelEvent: class {
    @objc func dataConfigured()
    @objc func dataSourceFail(with errMsg: String)
}

public protocol PaginationBaseViewModelEvent: BaseViewModelEvent {
    func setPagination(_ meta: KaoPagination?, object: Any)
}

open class BaseViewModel: NSObject {
    public weak var eventDelegate: BaseViewModelEvent?
    public weak var viewModelDelegate:BaseViewModelEvent?
}

// MARK: - BELOW TO BE DEPRECATED
public protocol BaseVMEventDelegate: class {
    func itemsConfigured()
}

open class TableViewModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    public var items: [TableViewVMProtocol] = []
    public var dataConfigured: (() -> Void)?
    public weak var eventDelegate: BaseVMEventDelegate?
    public weak var viewModelDelegate:BaseViewModelEvent?

    // MARK: - Notification Handle
    open func dropError(_ message: String) {
        KaoNotificationBanner.shared.dropNotification(.error, message: message)
    }

    open func dropSuccess(_ message: String) {
        KaoNotificationBanner.shared.dropNotification(.success, message: message)
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
}
