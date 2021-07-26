//
//  JsonHelper.swift
//  KaodimTests
//
//  Created by Augustius on 07/08/2019.
//  Copyright © 2019 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation

public struct JsonHelper<T: Decodable> {

    public static func convert(_ data: Any) -> T? {
        if let jsonStringify = data as? String {
            return self.convert(jsonStringify)
        } else if let jsonDict = data as? [String: Any] {
            return self.convert(jsonDict)
        } else {
            return nil
        }
    }

    public static func convert(_ json: [String: Any]) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return try T.decode(from: data)
        } catch {
            return nil
        }
    }

    public static func convert(_ jsonString: String) -> T? {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                return try T.decode(from: jsonData)
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}
