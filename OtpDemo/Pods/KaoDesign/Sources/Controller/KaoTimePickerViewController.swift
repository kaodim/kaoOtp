//
//  KaoTimePickerViewController.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 12/5/19.
//

import UIKit

public class KaoTimePickerViewController: KaoSlideUpViewController {

    private lazy var timePicker: KaoTimePicker = {
        let view = KaoTimePicker(localizedStrings)
        view.leftTap = { [weak self] in self?.leftDidTap() }
        view.selectedTime = { [weak self] date, surcharge, surchargeAmt, chargeType in
            self?.selectedTimeDidTap(date, surcharge: surcharge, surchargeAmt: surchargeAmt, chargeType)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public var localizedStrings: KaoCalendarLocalize!
    public var indicatorText = ""
    public var leftTap: (() -> Void)?
    public var rightTap: (() -> Void)?
    public var selectedTime: ((_ date: String, _ surcharge: String, _ surchargeAmt: Int?) -> Void)?

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.presentView = timePicker
        super.viewDidLoad()

        super.maxPresentHeight = phoneHasNotch ? UIScreen.main.bounds.height * 0.90 : UIScreen.main.bounds.height * 0.95
        super.presentViewHeight = phoneHasNotch ? UIScreen.main.bounds.height * 0.90 : UIScreen.main.bounds.height * 0.85
        configureIndicatorEdge(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }

    deinit {
        print("KaoTimePickerViewController deinit")
    }

    private func leftDidTap() {
        leftTap?()
    }

    private func selectedTimeDidTap(_ dateTime: String, surcharge: String, surchargeAmt: Int?, _ chargeType: ChargeType) {
        selectedTime?(dateTime, surcharge, surchargeAmt)
    }

    public func configureData(times: AvailabilityTime) {
        timePicker.dateModel = times
        timePicker.reloadData()
    }

    public func configureTimePickerMenu(_ menuTitle: String, rightButton: String) {
        timePicker.configureMenuHeader(menuTitle)
        timePicker.configureRightButton(rightButton)
    }

    public func configureTimePickerIndicator(_ indicatorTitle: String, indicatorImage: String = "surcharge_icon") {
        timePicker.configureIndicatorImage(indicatorImage)
        timePicker.configureIndicatorView(indicatorTitle)
    }

    public func configureIndicatorHeight(_ height: CGFloat = 39) {
        timePicker.adjustIndicatorHeight(height)
    }

    public func configureIndicatorEdge(_ edges: UIEdgeInsets) {
        timePicker.configureIndicatorEdge(edges)
    }

    public func hideIndicator(_ hide: Bool) {
        timePicker.hideIndicatorView(hide)
    }

    public func showLeftIcon(_ show: Bool) {
        timePicker.showLeftIcon(false)
    }

    public func shouldPush(_ isPush: Bool) {
        super.shouldPush = isPush
    }

    public func configureDateSurcharge(_ surcharge: String) {
        timePicker.dateSurcharge = surcharge
    }

    public func disableIndicatorView(_ disable: Bool) {
        timePicker.indicatorViewDisabled = disable
    }

    public func configureIndicatorText(_ text: String, _ chargeType: ChargeType) {
        if text.isEmpty {
            hideIndicator(true)
        } else {
            timePicker.configureIndicatorText(text, chargeType)
        }
    }

    public func configureTimeIndicatorText(_ completion: @escaping ((_ timeSlot: TimeSlot) -> Void)) {
        timePicker.getIndicatorText = { timeSlot in
            completion(timeSlot)
        }
    }
}

