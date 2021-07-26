//
//  PaymentCalculatorViewModel.swift
//  KaoDesign
//
//  Created by Ramkrishna on 20/05/2020.
//

import Foundation

public struct PaymentCalculaorCellData: Equatable {
    public var cellTitle = NSAttributedString(string: "")
    public var cellBtnTitle: String? = ""
    let leftTitleLabel: NSAttributedString
    let leftLabel: NSAttributedString?
    let rightLabel: NSAttributedString!
    public var leftIcon: UIImage? = nil
    public var leftIconURL: URL? = nil
    public var showTopView: Bool = false
    public var showTopViewLineSeperator: Bool = true
    public var showSeperatorLine: Bool = true
    public var showTopSeperatorLine: Bool = false

    public init(leftTitleLabel: NSAttributedString, leftLabel: NSAttributedString?, rightLabel: NSAttributedString, _ cellBtnTapped: @escaping(() -> Void)) {
        self.leftTitleLabel = leftTitleLabel
        self.leftLabel = leftLabel
        self.rightLabel = rightLabel
    }
}

public struct PaymentCalculatorData {

    public var header: PaymentCalculatorHeaderData?
    public var footer: PaymentCalculatorFooterData? = nil
    public var items = [PaymentCalculaorCellData]()
    public var bottomButtonTitle: String? = nil

    public mutating func updateButtonTitle(_ title: String) {
        bottomButtonTitle = title
    }
}

public struct PaymentCalculatorFooterData {
    public let startText: String
    public let icon: UIImage?
    public let endText: String

    public init(startText: String, icon: UIImage?, endText: String) {
        self.startText = startText
        self.icon = icon
        self.endText = endText
    }
}

protocol HandleEvents: BaseViewModelEvent {
    //func navigate(to destination: LoginNavigator.Destination)
}

open class PaymentCalculatorViewModel: BaseViewModel {
    public var paymentCalculatorData: PaymentCalculatorData? {
        didSet {

        }
    }

    public override init() {
        self.paymentCalculatorData = PaymentCalculatorData()
    }
}
