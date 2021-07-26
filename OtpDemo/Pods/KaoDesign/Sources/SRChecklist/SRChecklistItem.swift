//
//  SRChecklistItem.swift
//  KaoDesign
//
//  Created by Augustius on 17/12/2019.
//

import Foundation

public protocol SRChecklistItemEventDelegate: class {
    func reloadItem(_ item: SRChecklistItem)
}

open class SRChecklistItem: SRChecklistProtocolItem {

    public static func == (lhs: SRChecklistItem, rhs: SRChecklistItem) -> Bool {
        return lhs.checklist.id == rhs.checklist.id
    }

    private var needShowMore = false
    private var isExpanded = false
    private var maxShowList = 2 // update here for number of list shown first time

    public weak var eventDelegate: SRChecklistItemEventDelegate?

    public lazy var footerView: SRChecklistFooter = {
        let view = SRChecklistFooter()
        return view
    }()

    public lazy var headerView: SRChecklistHeader = {
        let view = SRChecklistHeader()
        view.configure(checklist.title)
        return view
    }()

    public var checklist: SRChecklist!
    private var localizedStrings: KaoCalendarLocalize!

    public var rowCount: Int {
        return configureRowCount()
    }

    // MARK: - init methods
    public init(_ checklist: SRChecklist, localizedStrings: KaoCalendarLocalize) {
        self.checklist = checklist
        self.localizedStrings = localizedStrings
        self.needShowMore = checklist.tasks.count > maxShowList
    }

    open func configureRowCount() -> Int {
        if needShowMore {
            return isExpanded ? checklist.tasks.count + 1 : maxShowList + 1
        } else {
            return checklist.tasks.count
        }
    }

    // MARK: - TableView DataSource & Delegates
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isShowMore = isExpanded ? indexPath.row == checklist.tasks.count : indexPath.row == maxShowList
        if needShowMore, isShowMore {
            let cell: SRChecklistShowAllCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureView(isExpanded, localizedStrings: localizedStrings)
            return cell
        } else {
            let cell: SRChecklistItemCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let task = checklist.tasks[indexPath.row]
            cell.configure(task.text)
            return cell
        }
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if needShowMore {
            let isShowMore = isExpanded ? indexPath.row == checklist.tasks.count : indexPath.row == maxShowList
            if isShowMore {
                isExpanded.toggle()
                eventDelegate?.reloadItem(self)
            }
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
