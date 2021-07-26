//
//  PaymentCalculaorCellItem.swift
//  KaoDesign
//
//  Created by Ramkrishna on 20/05/2020.
//

import Foundation

class PaymentCalculatorCellItem: TableViewVMProtocol {

    let cellItems: [PaymentCalculaorCellData]!
    var cellButtonTapped: (() -> Void)?
    var linkTapped: ((_ URL: URL, _ source: UIView) -> Void)?
    var leftIconTapped: ((_ URL: URL, _ source: UIView) -> Void)?
    var rowCount: Int {
        cellItems.count
    }

    init(_ cellItems: [PaymentCalculaorCellData]) {
        self.cellItems = cellItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PaymentCalculatorCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let cellModel = self.cellItems[indexPath.row]
        cell.configure(cellModel, indexPath.row == 0)
        cell.linkTapped = { [weak self] (url, source) in
            self?.linkTapped?(url, source)
        }

        cell.leftIconTapped = { [weak self] (url, source) in
            self?.leftIconTapped?(url, source)
        }

        if indexPath.row == 0 && cellModel.showTopView {
            cell.configureCellHeader(cellModel.cellTitle,
                btnTitle: cellModel.cellBtnTitle) { [weak self] in
                self?.cellButtonTapped?()
            }
        } else {
            cell.hideTopView()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}
