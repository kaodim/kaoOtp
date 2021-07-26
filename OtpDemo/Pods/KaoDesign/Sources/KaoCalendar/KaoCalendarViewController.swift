//
//  KaoCalendarViewController.swift
//  KaoDesign
//
//  Created by Ramkrishna on 09/07/2019.
//

import UIKit
import AZYCalendarView

public class KaoCalendarViewController: KaoBottomSheetController {

    var limitDaysRange: Int!
    var selectedDates: [Date]?
    var localizedStrings: KaoCalendarLocalize!
    private var enableFutureDates: Bool!

    init(limitDaysRange: Int, selectedDates: [Date]? = nil, localizedStrings: KaoCalendarLocalize, enableFutureDates: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.selectedDates = selectedDates
        self.limitDaysRange = limitDaysRange
        self.localizedStrings = localizedStrings
        self.enableFutureDates = enableFutureDates
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Var & Lets
    private lazy var calendarView: KaoCalenderView = {
        let calendarView = KaoCalenderView(self.selectedDates, localizedStrings)
        calendarView.resetDidTapped = resetDidTapped
        calendarView.doneTapped = dateSelected
        calendarView.enableFutureDates(self.enableFutureDates)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()


    public var doneTapped: ((_ selectedDates: [Date]) -> Void)?
    public var resetTapped: (() -> Void)?

    // MARK: - Controller Lifecycle
    override public func viewDidLoad() {
        super.presentView = calendarView
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.presentViewHeight = self.view.frame.height * 0.75
        super.viewWillAppear(animated)
    }

    private func showPopup() {
        let text1 = localizedStrings.localize(.selectDateRangeMessage)
        let message = [text1].joined(separator: "\n")
        let attrStr = NSMutableAttributedString(string: message)
        attrStr.addAttributes([NSAttributedString.Key.font: UIFont.kaoFont(style: .semibold, size: 20)
            ], range: NSRange(location: 0, length: text1.count))
        let view = KaoPopupViewControllers(attrStr, buttonText: localizedStrings.localize(.ok), cancelText: nil)
        view.modalPresentationStyle = .overCurrentContext
        view.secondButtonTapped = {
            view.dismissAnimation()
        }
        present(view, animated: false, completion: nil)
    }

    // MARK: - Callbacks
    private func resetDidTapped() {
        self.dismissAnimation()
        self.resetTapped?()
    }

    private func dateSelected(_ selectedDates: [Date]) {
        let startDate = selectedDates[0]
        let endDate = selectedDates[1]

        if limitDaysRange != 0 && endDate.days(from: startDate) > limitDaysRange {
            showPopup()
        } else {
            self.dismissAnimation {
                self.doneTapped?(selectedDates)
            }
        }
    }
}

// MARK: - Extension
extension UIViewController {
    public func presentKaoCalendar(limitDaysRange: Int? = 0, selectedDates: [Date]? = nil,
                                   _ doneTapped: ((_ selectedDates: [Date]) -> Void)?, _ resetTapped: (() -> Void)?, localizedStrings: KaoCalendarLocalize, enableFutureDates: Bool = true)
    {

        let view = KaoCalendarViewController(limitDaysRange: limitDaysRange ?? 0, selectedDates: selectedDates, localizedStrings: localizedStrings, enableFutureDates: enableFutureDates)
        view.doneTapped = doneTapped
        view.resetTapped = resetTapped
        view.modalPresentationStyle = .overFullScreen
        present(view, animated: false, completion: nil)
    }
}
