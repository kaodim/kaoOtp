//
//  SRPricingGuide.swift
//  KaoDesign
//
//  Created by Augustius on 16/12/2019.
//

import Foundation

public struct SRPricingGuideUnitItem: Decodable {
    public let itemText: String
    public let itemPriceText: String

    enum CodingKeys: String, CodingKey {
        case itemText = "unit_item_text"
        case itemPriceText = "unit_item_price_text"
    }
}

public extension SRPricingGuideUnitItem {
    init?(json: [String: Any]) {
        guard
            let itemText = json["unit_item_text"] as? String,
            let itemPriceText = json["unit_item_price_text"] as? String
            else { return nil }

        self.itemText = itemText
        self.itemPriceText = itemPriceText
    }

    static func initList(json: Any?) -> [SRPricingGuideUnitItem] {
        guard let arrayDictionary = json as? [[String: Any]] else {
            return []
        }
        return arrayDictionary.compactMap({ SRPricingGuideUnitItem(json: $0) ?? nil })
    }
}

public struct SRPricingGuide: Decodable {
    public let questionId: Int
    public let title: String
    public let unitTitle: String
    public let unitDesc: String
    public let unitItems: [SRPricingGuideUnitItem]

    enum CodingKeys: String, CodingKey {
        case questionId = "question_id"
        case title
        case unitTitle = "unit_title"
        case unitDesc = "unit_desc"
        case unitItems = "unit_items"
    }
}

public extension SRPricingGuide {
    init?(json: [String: Any]) {
        guard
            let questionId = json["question_id"] as? Int,
            let title = json["title"] as? String,
            let unitTitle = json["unit_title"] as? String,
            let unitDesc = json["unit_desc"] as? String
            else { return nil }

        self.questionId = questionId
        self.title = title
        self.unitTitle = unitTitle
        self.unitDesc = unitDesc
        self.unitItems = SRPricingGuideUnitItem.initList(json: json["unit_items"])
    }

    static func initList(json: Any?) -> [SRPricingGuide] {
        guard let arrayDictionary = json as? [[String: Any]] else {
            return []
        }
        return arrayDictionary.compactMap({ SRPricingGuide(json: $0) ?? nil })
    }
}
