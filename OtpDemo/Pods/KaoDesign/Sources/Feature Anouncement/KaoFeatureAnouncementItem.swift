//
//  KaoFeatureAnouncementItem.swift
//  KaoDesign
//
//  Created by Ramkrishna on 21/05/2020.
//

import Foundation

class KaoFeatureAnnouncementItem: TableViewVMProtocol {

    private var cellData: KaoFeatureAnnouncementCellData
    var buttonTapped: (() -> Void)?

    init(_ cellData: KaoFeatureAnnouncementCellData) {
        self.cellData = cellData
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: KaoFeatureAnnouncementCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.confiureText(text: cellData.text, cellData.buttonTitle, { [weak self] in
            self?.buttonTapped?()
        })

        if cellData.buttonTitle.isEmpty {
            cell.hideButtonView()
        }
        return cell
    }
}
