//
//  JobDetailsListingItem.swift
//  KaoDesign
//
//  Created by Ramkrishna on 21/05/2020.
//

import Foundation

open class JobDetailsListingItem: TableViewVMProtocol {

    public var rowCount: Int {
        items.cellItems.count
    }

    private var items: JobDetailsCellData!
    private var showTopSpace: Bool
    public init(_ items: JobDetailsCellData, _ showTopSpace: Bool = true) {
        self.items = items
        self.showTopSpace = showTopSpace
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: KaoIconAndTitleCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let cellModel = self.items.cellItems[indexPath.row]
        cell.configureData(cellModel)

        if indexPath.row == 0, showTopSpace {
            cell.configureFirstCell()
        }

        if indexPath.row == (indexPath.last) {
            cell.configureLastCell()
        }
        return cell
    }
}
