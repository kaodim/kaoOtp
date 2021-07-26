//
//  KaoPayMethod.swift
//  KaoDesign
//
//  Created by Augustius on 31/05/2019.
//
//  https://github.com/kaodim/kaodim-api-spec/blob/master/ada/payloads/service_request_summary.md

import Foundation

public struct KaoPayMethodGroup {
    public let payMethod: KaoPayMethod
    public let id: String

    public init(payMethod: KaoPayMethod, id: String) {
        self.payMethod = payMethod
        self.id = id
    }
}

public enum KaoPayMethod: String, Decodable {
    case kaodimpay, payAfterService = "pay_on_complete", cashOnComplete = "cash_on_complete"
}

public extension KaoPayMethod {
    static func initList(list: [String]) -> [KaoPayMethod]? {
        return list.compactMap({
            KaoPayMethod(rawValue: $0)
        })
    }
}

public struct KaoPayMethodDetail {
    public let payMethod: KaoPayMethodGroup
    public let title: String
    public let message: String
    public let extraParam: KaoPayMethodDetailExtra?
    public var tag = ""
    public var toolTipMessage = ""
    public var enabled = true
    public var id: Int

    public init(_ payMethod: KaoPayMethodGroup,id: Int, title: String, message: String, enabled: Bool, extraParam: KaoPayMethodDetailExtra? = nil) {
        self.id = id
        self.payMethod = payMethod
        self.title = title
        self.message = message
        self.extraParam = extraParam
        self.enabled = enabled
    }
}

public struct KaoPayMethodDetailExtra {
    public let desc1: String?
    public let desc2: String?
    public let icon: UIImage?
    public let bankLogos: UIImage?

    public init(desc1: String?, desc2: String?, icon: UIImage?, bankLogos: UIImage?) {
        self.desc1 = desc1
        self.desc2 = desc2
        self.icon = icon
        self.bankLogos = bankLogos
    }
}
