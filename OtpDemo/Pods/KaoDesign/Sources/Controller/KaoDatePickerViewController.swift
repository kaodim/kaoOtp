//
//  KaoDatePickerViewController.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 12/9/19.
//

import UIKit

public class KaoDatePickerViewController: KaoSlideUpViewController {

    private lazy var datePicker: KaoDatePicker = {
        let view = KaoDatePicker(localizedStrings)
        view.selectedDateValue = { [weak self] (day, indexPath) in self?.setDateValue(day, indexPath: indexPath) }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public var dateModel: AvailabilityCalendar? {
        didSet {
            datePicker.dateModel = configureData()
            datePicker.reloadData()
        }
    }

    public var localizedStrings: KaoCalendarLocalize!
    public var selectedDateValue: ((_ day: CalendarDay?, _ indexPath: IndexPath) -> Void)?
    public var shouldDismiss = false
    public var leftTap: (() -> Void)?
    public var rightTap: (() -> Void)?

    override public func viewDidLoad() {
        super.presentView = datePicker
        super.viewDidLoad()
        datePicker.leftTap = { [weak self] in self?.leftDidTap() }
        datePicker.rightTap = { [weak self] in self?.rightDidTap() }

        super.maxPresentHeight = phoneHasNotch ? UIScreen.main.bounds.height * 0.90 : UIScreen.main.bounds.height * 0.95
        super.presentViewHeight = phoneHasNotch ? UIScreen.main.bounds.height * 0.90 : UIScreen.main.bounds.height * 0.85
    }

    deinit {
        print("KaoDatePickerViewController deinit")
    }

    public func configureDatePickerMenu(_ menuTitle: String, leftIcon: String = "icons_header_close") {
        datePicker.configureMenuHeader(menuTitle)
        datePicker.configureLeftIcon(leftIcon)
    }

    public func configureDatePickerIndicator(_ indicatorTitle: String, indicatorImage: String = "surcharge_icon") {
        datePicker.configureIndicatorImage(indicatorImage)
        datePicker.configureIndicatorView(indicatorTitle)
    }

    public func configureIndicatorText(_ indicatorTitle: String) {
        datePicker.configureIndicatorView(indicatorTitle)
        datePicker.showLeftIcon(false)
    }

    public func configureIndicatorEdge(_ edges: UIEdgeInsets) {
        datePicker.configureIndicatorEdge(edges)
    }

    public func configureDatePickerGif(_ indicatorTitle: String, surcharge: String = "surcharge_arrow", rebate: String = "rebate_arrow_gif") {
        if !indicatorTitle.isEmpty {
            if let surchargable = dateModel?.meta.surchargable, let rebatable = dateModel?.meta.rebatable {
                if surchargable && rebatable {
                    datePicker.configureIndicatorGif(surcharge, rebate)
                } else if surchargable && !rebatable {
                    datePicker.configureIndicatorGif(surcharge, nil)
                } else {
                    datePicker.configureIndicatorGif(rebate, nil)
                }
            }
            datePicker.configureIndicatorView(indicatorTitle)
        }
    }

    public func showLeftIcon(_ show: Bool) {
        datePicker.showLeftIcon(false)
    }

    public func configureIndicatorHeight(_ height: CGFloat = 39) {
        datePicker.adjustIndicatorHeight(height)
    }

    public func configureSelection(_ selectedDates: [IndexPath]) {
        datePicker.selectedDate = selectedDates
    }

    public func hideIndicator(_ hide: Bool) {
        datePicker.hideIndicatorView(hide)
    }

    private func setDateValue(_ day: CalendarDay?, indexPath: IndexPath) {
        selectedDateValue?(day, indexPath)
        if shouldDismiss {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.dismissAnimation()
            }
        }
    }

    private func configureData() -> AvailabilityCalendar {
        var modifiedSurchargeDates = [CalendarDay]()
        var modifiedDateTime: [CalendarMonth] = []

        dateModel?.calendarMonths?.forEach({ (calendarDay) in
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
        let modifiedModel = AvailabilityCalendar(calendarMonths: modifiedDateTime, meta: dateModel?.meta ?? CalendarMeta(surchargable: false, rebatable: false))
        return modifiedModel
    }

    private func leftDidTap() {
        leftTap?()
    }

    private func rightDidTap() {
        rightTap?()
    }
}

