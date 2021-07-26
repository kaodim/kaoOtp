//
//  SRInfoItem.swift
//  KaoDesign
//
//  Created by Augustius on 20/12/2019.
//

import Foundation

open class SRInfoItem: TableViewVMProtocol {

    private var desc: String = ""
    private var icon: UIImage?
    private var footerHeight: CGFloat = 0
    private var headerHeight: CGFloat = 0
    public var cellTapped: (() -> Void)?

    public init(_ desc: String, icon: UIImage?, footerHeight: CGFloat = 0, headerHeight: CGFloat = 0) {
        self.desc = desc
        self.icon = icon
        self.footerHeight = footerHeight
        self.headerHeight = headerHeight
    }

    // MARK: - TableView DataSource & Delegates
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SRInfoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(desc, icon: icon)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellTapped?()
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
}

