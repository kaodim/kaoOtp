//
//  PaymentViewModel.swift
//  KaoDesign
//
//  Created by Ramkrishna on 22/05/2020.
//

import Foundation

public enum PaymentAlertType {
    case info
    case error
}

public struct PaymentAlertData {
    var alertTypes: PaymentAlertType
    var message: String
    var icon: UIImage?
    var textColor: UIColor

    public init(alertTypes: PaymentAlertType,
        message: String,
        icon: UIImage?,
        textColor: UIColor) {
        self.alertTypes = alertTypes
        self.message = message
        self.icon = icon
        self.textColor = textColor
    }
}

public struct PaymentData {
    var minimumInputAmount: Double!
    var alertTypes: [PaymentAlertData] = []

    public init(minimumInputAmount: Double, alertTypes: [PaymentAlertData]) {
        self.minimumInputAmount = minimumInputAmount
        self.alertTypes = alertTypes
    }

}

open class PaymentViewModel {
    let paymentData: PaymentData!
    let header: PaymentCalculatorHeaderData!

    var isValidAmount = false

    public init(_ paymentData: PaymentData, header: PaymentCalculatorHeaderData) {
        self.paymentData = paymentData
        self.header = header
    }

    func validateAmount(_ amount: Double) -> Bool {
        print(amount)
        print(paymentData.minimumInputAmount)
        print(amount >= (paymentData.minimumInputAmount))
        return amount >= (paymentData.minimumInputAmount)
    }

    func getAlertMessage(_ amount: Double) -> PaymentAlertData? {
        if self.validateAmount(amount) {
            if let infoAlert = self.paymentData.alertTypes.filter({ $0.alertTypes == .info }).first {
                return infoAlert
            }
        }
        let errorAlert = self.paymentData.alertTypes.filter({ $0.alertTypes == .error }).first
        return errorAlert
    }
}
