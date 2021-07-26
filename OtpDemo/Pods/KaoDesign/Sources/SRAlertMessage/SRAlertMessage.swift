//
//  SRAlertMessage.swift
//  KaoDesign
//
//  Created by Augustius on 03/12/2019.
//

import Foundation

public enum SRAlertMessageType: String, Decodable {
    case info, warning, danger
}

public enum SRAlertMessageIcon: String, Decodable {
    case success, pending = "pending_action", alert
}

public struct SRAlertMessage: Decodable {
    public let message: String
    public let type: SRAlertMessageType
    public let icon: SRAlertMessageIcon?

    public init?(json: [String: Any]) {
        guard
            let message = json["message"] as? String,
            let typeRaw = json["type"] as? String,
            let type = SRAlertMessageType(rawValue: typeRaw)
            else { return nil }

        self.message = message
        self.type = type
        self.icon = SRAlertMessageIcon(rawValue: json["icon"] as? String ?? "")
    }

    static public func initList(json: Any?) -> [SRAlertMessage] {
        guard let arrayDictionary = json as? [[String: Any]] else {
            return []
        }
        return arrayDictionary.compactMap({ SRAlertMessage(json: $0) ?? nil })
    }
}
