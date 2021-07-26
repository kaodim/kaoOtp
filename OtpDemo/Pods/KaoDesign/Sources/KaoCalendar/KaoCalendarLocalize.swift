//
//  KaoCalendarLocalize.swift
//  KaoDesign
//
//  Created by Ramkrishna on 07/08/2019.
//

import Foundation

public enum KaoCalendarLocalizeKey: String {
    case mon, tue, wed, thu, fri, sat, sun
    case selectDateRangeMessage,ok
    case selectDateRangeTitle
    case reset,done
    case selectStartDate,selectEndDate,startDate,endDate
    case morning, afternoon, evening
    case showAllItems, showLessItems
}

public struct KaoCalendarLocalize {
    public init() { }
    var localizeStrings = [String: String]()
}

public extension KaoCalendarLocalize {
    mutating func addLocalizedStrings(key: KaoCalendarLocalizeKey, value: String) {
        self.localizeStrings[key.rawValue] = value
    }

    func localize(_ key: KaoCalendarLocalizeKey) -> String {
        return self.localizeStrings[key.rawValue] ?? "-\(key.rawValue)-"
    }
}
