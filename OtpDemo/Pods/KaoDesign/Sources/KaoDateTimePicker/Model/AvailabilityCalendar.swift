//
//  DateTimeModel.swift
//  Kaodim
//
//  Created by Ramkrishna Baddi on 11/12/18.
//  Copyright © 2018 Kaodim Sdn Bhd. All rights reserved.
//

import UIKit

public enum ChargeType {
    case positive
    case negative
    case both
    case none
}

public struct CalendarMeta: Codable {
    public let surchargable: Bool
    public let rebatable: Bool

    public init(surchargable: Bool, rebatable: Bool) {
        self.surchargable = surchargable
        self.rebatable = rebatable
    }

    enum CodingKeys: String, CodingKey {
        case surchargable
        case rebatable
    }
}

public struct AvailabilityCalendar: Codable {
    var calendarMonths: [CalendarMonth]?
    public let meta: CalendarMeta

    public init(calendarMonths: [CalendarMonth], meta: CalendarMeta) {
        self.calendarMonths = calendarMonths
        self.meta = meta
    }

    enum CodingKeys: String, CodingKey {
        case calendarMonths = "calendar_months"
        case meta
    }
}

public struct CalendarMonth: Codable, Equatable {

    let month: Int
    let year: Int
    let surchargable: Bool
    let days: [CalendarDay]?

    public init(month: Int, year: Int, surchargable: Bool = false, days: [CalendarDay]) {
        self.month = month
        self.year = year
        self.surchargable = surchargable
        self.days = days
    }

    enum CodingKeys: String, CodingKey {
        case month, year, surchargable, days
    }


    public static func == (lhs: CalendarMonth, rhs: CalendarMonth) -> Bool {
        return true
    }
}

public struct CalendarDay: Codable, Equatable {

    public let value: String?
    let available: Bool?
    public let price: Int?
    public let localizedPrice: String?
    let readablePrice: String?
    let showPrice: Bool?
    public let surchargable: Bool?
    public let rebatable: Bool?
    let timeslots: [AvailabilityTime]?

    public init(value: String? = nil, available: Bool = true, price: Int? = nil, localizedPrice: String? = nil, readablePrice: String? = nil, showPrice: Bool? = nil, surchargable: Bool? = nil, rebatable: Bool? = nil, timeslots: [AvailabilityTime]? = nil) {
        self.value = value
        self.available = available
        self.price = price
        self.localizedPrice = localizedPrice
        self.readablePrice = readablePrice
        self.showPrice = showPrice
        self.surchargable = surchargable
        self.rebatable = rebatable
        self.timeslots = timeslots
    }

    enum CodingKeys: String, CodingKey {
        case value, available, price, surchargable, timeslots, rebatable
        case localizedPrice = "localized_total_price"
        case readablePrice = "human_readable_price"
        case showPrice = "show_price"
    }

    public static func == (lhs: CalendarDay, rhs: CalendarDay) -> Bool {
        return true
    }

    public static func empty() -> CalendarDay {
        return CalendarDay(value: nil, available: false, price: nil, localizedPrice: nil, readablePrice: nil, showPrice: nil, surchargable: nil, timeslots: nil)
    }
}

//MARK:- Time Model
public struct AvailabilityTime: Codable {
    let timeslots: [TimeSlot]
    public let meta: CalendarMeta

    public init(timeslots: [TimeSlot], meta: CalendarMeta) {
        self.timeslots = timeslots
        self.meta = meta
    }

    enum CodingKeys: String, CodingKey {
        case timeslots, meta
    }
}

extension AvailabilityTime {
    func containSurcharge() -> Bool {
        return self.meta.rebatable || self.meta.surchargable
    }
}

public struct TimeSlot: Codable {
    public let value: String
    let available: Bool
    public let price: Int
    public let readablePrice: String
    public let localizedTotalPrice: String
    let showPrice: Bool
    public let surchargable: Bool
    public let rebatable: Bool
    public let totalPrice: FormFieldValueType

    public init(value: String, available: Bool = true, price: Int = 0, readablePrice: String = "", localizedTotalPrice: String = "", showPrice: Bool = false, surchargable: Bool = false, rebatable: Bool = false, totalPrice: FormFieldValueType) {
        self.value = value
        self.available = available
        self.price = price
        self.readablePrice = readablePrice
        self.localizedTotalPrice = localizedTotalPrice
        self.showPrice = showPrice
        self.surchargable = surchargable
        self.rebatable = rebatable
        self.totalPrice = totalPrice
    }

    enum CodingKeys: String, CodingKey {
        case value, available, price, surchargable, rebatable
        case readablePrice = "human_readable_price"
        case localizedTotalPrice = "localized_total_price"
        case showPrice = "show_price"
        case totalPrice = "total_price"
    }
}

public enum FormFieldValueType: Codable {
    case intValue(Int)
    case stringValue(String)
    case doubleValue(Double)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .stringValue(value)
        } else if let value = try? container.decode(Double.self) {
            self = .doubleValue(value)
        } else if let value = try? container.decode(Int.self) {
            self = .intValue(value)
        } else {
            fatalError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .stringValue(let value):
            try container.encode(value)
        case .doubleValue(let value):
            try container.encode(value)
        case .intValue(let value):
            try container.encode(value)
        }
    }
}

extension FormFieldValueType {
    public func toString() -> String {
        switch self {
        case .doubleValue(let val):
            return "\(val)"
        case .intValue(let val):
            return "\(val)"
        case .stringValue(let val):
            return val
        }
    }
}
