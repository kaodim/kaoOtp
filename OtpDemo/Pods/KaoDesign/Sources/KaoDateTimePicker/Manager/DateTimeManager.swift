//
//  DateTimeManager.swift
//  Kaodim
//
//  Created by Ramkrishna Baddi on 11/12/18.
//  Copyright © 2018 Kaodim Sdn Bhd. All rights reserved.
//

import UIKit

public class DateTimeManager {
        
    public class func getController(_ json: String?) -> UIViewController? {
        do {
            guard let jsonWrapped    = json else { return nil }
            guard let rawData = jsonWrapped.data(using: .utf8) else { return nil }
            let decoder = try JSONDecoder().decode(AvailabilityCalendar.self, from: rawData)

            var localizeStrings = KaoCalendarLocalize()
            localizeStrings.addLocalizedStrings(key: .mon, value: "mon")
            localizeStrings.addLocalizedStrings(key: .tue, value: "mon")
            localizeStrings.addLocalizedStrings(key: .wed, value: "mon")
            localizeStrings.addLocalizedStrings(key: .thu, value: "mon")
            localizeStrings.addLocalizedStrings(key: .fri, value: "mon")
            localizeStrings.addLocalizedStrings(key: .sat, value: "mon")
            localizeStrings.addLocalizedStrings(key: .sun, value: "mon")

            let view = KaoDatePickerViewController()
            view.localizedStrings = localizeStrings
            var modifiedSurchargeDates = [CalendarDay]()
            var modifiedDateTime: [CalendarMonth] = []

            let model = decoder
            model.calendarMonths?.forEach({ (calendarDay) in
                guard let firstDateOfTheMonth = calendarDay.days?.first?.value?.toDate() else { return }
                
                let noOfEmptyDaysOfMonth = Days.init(rawValue: firstDateOfTheMonth.getDay())?.getEmptyDays()
                if let count = noOfEmptyDaysOfMonth {
                    // add empty days based on how many empty days in a month
                    for _ in 0..<count {
                        modifiedSurchargeDates.append(CalendarDay.empty())
                    }
                }
                modifiedSurchargeDates += calendarDay.days ?? []

                let date = CalendarMonth(month: calendarDay.month, year: calendarDay.year, surchargable: calendarDay.surchargable, days: modifiedSurchargeDates)
                modifiedDateTime.append(date)

                modifiedSurchargeDates = []
            })
            let dateModel = AvailabilityCalendar(calendarMonths: modifiedDateTime, meta: decoder.meta)
            view.dateModel = dateModel

            return view
        } catch {}
        return nil
    }
    
    
    public class func getTimeController(_ json: String?) -> UIViewController? {
//        do {
//            guard let jsonWrapped    = json else { return nil }
//            guard let rawData = jsonWrapped.data(using: .utf8) else { return nil }
//            let decoder = try JSONDecoder().decode(AvailabilityTime.self, from: rawData)
//
//            let view = KaoTimePickerViewController(times: decoder)
//            return view
//        } catch {
//            print(error)
//        }
        return nil
        
    }
}
