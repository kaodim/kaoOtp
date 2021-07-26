//
//  Encodable+Extension.swift
//  KaoDesign
//
//  Created by augustius cokroe on 06/03/2019.
//

import Foundation

public extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }

    func jsonStringify() -> String? {
        var textData: String?
        do {
            let data = try JSONEncoder().encode(self)
            textData = String(data: data, encoding: .utf8)
        } catch { return nil }
        return textData
    }
}
