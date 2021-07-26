//
//  KaoTimePicker.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 12/5/19.
//

import UIKit

public class KaoTimePicker: UIView {

    @IBOutlet private weak var menuHeader: KaoHeaderMenu!
    @IBOutlet private weak var spacerHeight: NSLayoutConstraint!
    @IBOutlet private weak var indicatorViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var indicatorView: KaoIndicatorView!
    @IBOutlet private weak var tableView: UITableView!

    var dateModel: AvailabilityTime? = nil {
        didSet {
            for time in dateModel?.timeslots ?? [] {
                handleTime(time: time)
            }
            createTime()
        }
    }

    public var localizedStrings: KaoCalendarLocalize!
    public var timeSection: [String] = []
    public var completeTime = [[TimeSlot]]()
    public var morning: [TimeSlot] = []
    public var afternoon: [TimeSlot] = []
    public var evening: [TimeSlot] = []
    public var dateSurcharge = ""
    public var highDemandText = ""
    private var chargeType: ChargeType = .none

    public var leftTap: (() -> Void)?
    public var rightTap: (() -> Void)?
    public var selectedTime: ((_ dateTime: String, _ surcharge: String, _ surchargeAmt: Int?, _ chargeType: ChargeType) -> Void)?
    public var getIndicatorText: ((TimeSlot) -> Void)?

    private var totalDateTimeSurcharge = ""
    private var totalDateTimeSurchargeAmt: Int?
    private var selectedDateTime = ""
    public var hasSurcharge = false
    public var indicatorViewDisabled = false {
        didSet {
            hideIndicatorView(indicatorViewDisabled)
        }
    }
    private var contentView: UIView!

    // MARK: - init methods    
    init(_ localizedStrings: KaoCalendarLocalize) {
        super.init(frame: .zero)
        self.localizedStrings = localizedStrings
        setupViews()
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    // MARK: - Setup UI
    private func setupViews() {
        contentView = loadFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
        configureTableView()
        configureView()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoTimePicker")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(KaoGenericTableCell<KaoTimeView>.self, forCellReuseIdentifier: KaoTimeView.reuseIdentifier)
        tableView.estimatedRowHeight = 65.0
        tableView.contentInset.bottom = 200.0
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func configureView() {
        indicatorView.configureEdges(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        menuHeader.configureLeftButtonIcon("icon_mini_left")
        menuHeader.leftTap = leftDidTap
        menuHeader.rightTap = rightDidTap
        menuHeader.hideRightIcon(true)
    }

    private func leftDidTap() {
        leftTap?()
    }

    private func rightDidTap() {
        selectedTime?(selectedDateTime, totalDateTimeSurcharge, totalDateTimeSurchargeAmt, chargeType)
    }

    private func configureSelectedDateTime(_ dateTime: String, _ totalSurcharge: String, _ timeSurcharge: String, _ surchargeAmt: Int?, _ chargeType: ChargeType) {
        _ = dateTime.toDate()
        selectedDateTime = dateTime
        totalDateTimeSurcharge = totalSurcharge
        totalDateTimeSurchargeAmt = surchargeAmt

    }
    
    public func reloadData() {
        tableView.reloadData()
    }

    public func configureSelectedDateTime(_ timeSlot: TimeSlot) {
        _ = timeSlot.value.toDate()
        selectedDateTime = timeSlot.value
        totalDateTimeSurcharge = timeSlot.localizedTotalPrice
        totalDateTimeSurchargeAmt = (timeSlot.totalPrice.toString() as NSString).integerValue
        self.getIndicatorText?(timeSlot)
    }

    public func showLeftIcon(_ show: Bool) {
        indicatorView.showLeftIcon(show)
    }

    private func configureSelectionButton(_ selected: Bool) {
        menuHeader.hideRightIcon(!selected)
        selectedDateTime = selected ? selectedDateTime : ""
        tableView.reloadData()
    }

    public func configureIndicatorView(_ text: String) {
        if !text.isEmpty {
            hideIndicatorView(false)
            indicatorView.configureType(.orange)
            indicatorView.configureDescription(text)
        }
    }

    public func configureIndicatorText(_ text: String, _ chargeType: ChargeType) {
        highDemandText = text
        hideIndicatorView(false)
        configureIndicatorGif(chargeType)
        indicatorView.configureType(.orange)
        indicatorView.configureDescription(text)
    }

    public func configureIndicatorGif(_ chargeType: ChargeType) {
        let surcharge = "surcharge_arrow"
        let rebate = "rebate_arrow_gif"
        if chargeType == .both {
            indicatorView.configureIconGif(surcharge, rebate)
        } else if chargeType == .positive {
            indicatorView.configureIconGif(surcharge, nil)
        } else if chargeType == .negative {
            indicatorView.configureIconGif(rebate, nil)
        }
    }

    public func hideIndicatorView(_ isHidden: Bool) {
        indicatorViewHeight.constant = isHidden ? 0 : 40
        spacerHeight.constant = isHidden ? 0 : 23
    }

    public func adjustIndicatorHeight(_ height: CGFloat) {
        indicatorViewHeight.constant = height
    }

    public func configureIndicatorEdge(_ edges: UIEdgeInsets) {
        indicatorView.configureEdges(edges)
    }

    public func configureMenuHeader(_ title: String) {
        menuHeader.configureTitle(title)
    }

    public func configureRightButton(_ title: String) {
        menuHeader.configureRightButtonTitle(title, color: UIColor.kaoColor(.vividBlue))
    }

    public func configureIndicatorImage(_ image: String) {
        indicatorView.configureIconFromLibrary(image)
    }

    private func handleTime(time: TimeSlot) {
        guard let dateFormat = time.value.toDate() else { return }

        let twentyFourHour = Int(dateFormat.getTime()) ?? 0

        switch twentyFourHour {
        case 600..<1201:
            morning.append(time)
        case 1230..<1701:
            afternoon.append(time)
        case 1730..<2301:
            evening.append(time)
        default:
            break
        }
    }

    private func createTime() {
        if !morning.isEmpty {
            completeTime.append(morning)
            timeSection.append(localizedStrings.localize(.morning))
        }

        if !afternoon.isEmpty {
            completeTime.append(afternoon)
            timeSection.append(localizedStrings.localize(.afternoon))
        }

        if !evening.isEmpty {
            completeTime.append(evening)
            timeSection.append(localizedStrings.localize(.evening))
        }
    }
}

extension KaoTimePicker: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return timeSection.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: KaoTimeView.reuseIdentifier, for: indexPath) as? KaoGenericTableCell<KaoTimeView> else {
            fatalError("KaoTimeView not found")
        }

        cell.selectionStyle = .none
        let section = timeSection[indexPath.section]
        (cell.customView as? KaoTimeView)?.configureTime(section)
        (cell.customView as? KaoTimeView)?.selectedTime = { date, _, _, _, _ in
            let timeSlots = self.completeTime[indexPath.section]
            if let timeSlot = timeSlots.first(where: { $0.value == date }) {
                self.configureSelectedDateTime(timeSlot)
            }

            print("\(indexPath.section) -- \(indexPath.row)")
        }
        (cell.customView as? KaoTimeView)?.isSelected = configureSelectionButton
        (cell.customView as? KaoTimeView)?.configureSelection(selectedDateTime)

        let date = completeTime[indexPath.section]
        (cell.customView as? KaoTimeView)?.configureCollectionView(date, hasSurcharge: dateModel?.meta.surchargable ?? false || dateModel?.meta.rebatable ?? false, chargeType)
        return cell
    }
}
