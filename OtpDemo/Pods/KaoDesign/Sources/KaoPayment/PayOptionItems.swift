//
//  PayOptionItems.swift
//  KaoDesign
//
//  Created by Augustius on 31/05/2019.
//

import Foundation

public class PayOptionItems: TableViewVMProtocol {
    public var rowCount: Int {
        return payMethodDetails.count
    }

    private lazy var header: KaoHeaderView = {
        let view = KaoHeaderView()
        view.configure(headerTitle)
        return view
    }()

    private var headerTitle: String = ""
    private var payMethodDetails: [KaoPayMethodDetail]
    private var selectedMethod: KaoPayMethodGroup?
    public var selectedPaymentGateway: PayOptionItemModel?
    public var payMethodSelected: ((_ payMethod: KaoPayMethodGroup) -> Void)?
    public var toolTipTap: ((_ indexPath: IndexPath, _ itemInfo: ItemInfo) -> Void)?

    public init(_ selectedMethod: KaoPayMethodGroup?, payMethodDetails: [KaoPayMethodDetail], headerTitle: String) {
        self.selectedMethod = selectedMethod
        self.payMethodDetails = payMethodDetails
        self.headerTitle = headerTitle
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = payMethodDetails[indexPath.row]
        let extraParam = detail.extraParam
        var selected = selectedMethod?.id == detail.payMethod.id
        let isLastRow = indexPath.row == (rowCount - 1)

        var cell: PayOptionProtocolCell!
        if detail.payMethod.id == KaoPayMethod.kaodimpay.rawValue {
            cell = KaodimPayOptionCell.tableView(tableView, cellForRowAt: indexPath)
            // Code to show the tool tip
            (cell as? KaodimPayOptionCell)?.toolTipTap = { [weak self] message in
                self?.toolTipTap?(indexPath, ItemInfo(description: message, deeplinkUrl: "", weblinkUrl: ""))
            }
        } else {
            cell = PayOptionCell.tableView(tableView, cellForRowAt: indexPath)
        }

        cell.configure(detail.title, message: detail.message)
        cell.configureIcon(detail.enabled, extraParam?.icon, detail.tag, detail.toolTipMessage)
        cell.hideSeperator(isLastRow)

        if let paymentMethod = selectedPaymentGateway {
            if selected && detail.payMethod.id == KaoPayMethod.kaodimpay.rawValue {
                cell.configurePaymentOptionSelected(paymentMethod: paymentMethod)
            }
        } else {
            if detail.payMethod.id == KaoPayMethod.kaodimpay.rawValue {
                selected = false
            }
        }
        print("PayOptionItems \(detail.title) : \(detail.enabled)")
        cell.configureEnabled(detail.enabled)
        cell.configure(extraParam?.desc1, desc2: extraParam?.desc2)
        cell.configureSelected(selected)
        cell.configureBankLogos(extraParam?.bankLogos)

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = payMethodDetails[indexPath.row]
        if detail.payMethod.id == KaoPayMethod.kaodimpay.rawValue {
            payMethodSelected?(detail.payMethod)
        } else {
            if detail.enabled {
                payMethodSelected?(detail.payMethod)
            }
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
