//
//  Decodable+Extension.swift
//  KaoDesign
//
//  Created by augustius cokroe on 06/03/2019.
//

import Foundation

public extension Decodable {
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }

    init?(json: [String: Any]) {
        guard let creditPackage = JsonHelper<Self>.convert(json) else { return nil }
        self = creditPackage
    }

    init(from: Any) throws {
      let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
      let decoder = JSONDecoder()
      self = try decoder.decode(Self.self, from: data)
    }

    static func initList(json: Any?) -> [Self] {
        guard let arrayDictionary = json as? [[String: Any]] else {
            return []
        }
        return arrayDictionary.compactMap({ self.init(json: $0) })
    }
}
