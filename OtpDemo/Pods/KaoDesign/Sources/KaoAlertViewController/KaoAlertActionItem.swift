//
//  KaoAlertActionItem.swift
//  Kaodim
//
//  Created by Ramkrishna on 26/06/2019.
//  Copyright © 2019 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation

class KaoAlertActionItem: TableViewVMProtocol {
    private var actionItems: [KaoAlertOption]
    private var footerView: UIView?
    private var headerTitle: String?

    public var rowCount: Int {
        return self.actionItems.count
    }

    var didSelectRow: ((_ completion: (() -> Void)?) -> Void)?

    // MARK: - init methods

    init(_ actionItems: [KaoAlertOption], _ footerView: UIView?, _ headerTitle: String? = nil) {
        self.actionItems = actionItems
        self.footerView = footerView
        self.headerTitle = headerTitle
    }

    // MARK: - TableView DataSource & Delegates

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: KaoAlertActionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let option = actionItems[indexPath.row]
        cell.configure(option.title)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = actionItems[indexPath.row]
        didSelectRow?({
            option.handler?()
        })
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = headerTitle else { return UIView.init() }
        let headerView = KaoHeaderView()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let attrString = NSMutableAttributedString.init(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.kaoFont(style: .regular, size: 15),
            NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.dimGray),
            NSAttributedString.Key.paragraphStyle: paragraph
            ])

        headerView.configure(attrString)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = headerTitle else { return 0 }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
