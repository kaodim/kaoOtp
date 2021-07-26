//
//  SRPricingGuideItem.swift
//  KaoDesign
//
//  Created by Augustius on 19/12/2019.
//

import Foundation

public class SRPricingGuideItem: TableViewVMProtocol {

    private lazy var footerView: SRChecklistFooter = {
        let view = SRChecklistFooter()
        return view
    }()

    private lazy var headerView: SRChecklistHeader = {
        let view = SRChecklistHeader()
        view.configure(pricingGuide.title)
        return view
    }()

    private var pricingGuide: SRPricingGuide!

    public var rowCount: Int {
        return self.pricingGuide.unitItems.count + 1
    }

    // MARK: - init methods
    public init(_ pricingGuide: SRPricingGuide) {
        self.pricingGuide = pricingGuide
    }

    // MARK: - TableView DataSource & Delegates
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let firstRow = indexPath.row == 0
        if firstRow {
            let cell: SRPricingGuideUnitCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(pricingGuide.unitTitle, desc: pricingGuide.unitDesc)
            return cell
        } else {
            let cell: SRPricingGuideUnitItemCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let unitItem = pricingGuide.unitItems[indexPath.row - 1]
            cell.configure(unitItem.itemText, desc: unitItem.itemPriceText)
            return cell
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
