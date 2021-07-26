//
//  KaoCalenderView.swift
//  KaoDesign
//
//  Created by Ramkrishna on 09/07/2019.
//
import UIKit
import AZYCalendarView

class KaoCalenderView: UIView {

    // MARK: - Var & Lets
    private var containerView: UIView!

    @IBOutlet private weak var calendarView: UIView!
    @IBOutlet private weak var weekTitleView: UIView!
    @IBOutlet private weak var doneBtn: UIButton!

    @IBOutlet private weak var startDateTitle: UILabel!
    @IBOutlet private weak var endDateTitle: UILabel!

    @IBOutlet private weak var startDate: UILabel!
    @IBOutlet private weak var endDate: UILabel!

    @IBOutlet private weak var startMonthTitle: UILabel!
    @IBOutlet private weak var endMonthTitle: UILabel!

    @IBOutlet private weak var startDayTitle: UILabel!
    @IBOutlet private weak var endDayTitle: UILabel!

    @IBOutlet private weak var startSelectDate: UILabel!
    @IBOutlet private weak var endSelectDate: UILabel!

    @IBOutlet private weak var startDateView: UIView!
    @IBOutlet private weak var endDateView: UIView!

    @IBOutlet private weak var resetBtn: UIButton!
    @IBOutlet private weak var selectDateRange: UILabel!

    private var selectedDates = [Date]()


    public var resetDidTapped: (() -> Void)?
    public var doneTapped: ((_ selectedDates: [Date]) -> Void)?
    public var showAlert: (() -> Void)?

    var calendarContentView: ZYCalendarView!
    var localizedStrings: KaoCalendarLocalize!
    // MARK: - init methods
    init(_ selectedDates: [Date]?, _ localizedStrings: KaoCalendarLocalize) {
        super.init(frame: .zero)
        self.selectedDates = selectedDates ?? [Date]()
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
        containerView = loadViewFromNib()
        containerView.frame = frame
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupUI()
        setupCalendarView()
        addSubview(containerView)
    }

    private func setupUI() {
        resetStartDate()
        resetEndDate()

        resetBtn.setTitle(localizedStrings.localize(.reset), for: .normal)
        doneBtn.setTitle(localizedStrings.localize(.done), for: .normal)

        selectDateRange.text = localizedStrings.localize(.selectDateRangeTitle)

        resetBtn.setTitleColor(UIColor.kaoColor(.vividBlue), for: .normal)
        doneBtn.setTitleColor(UIColor.kaoColor(.vividBlue), for: .normal)
    }

    private func loadViewFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoCalenderView")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }


    private func setupCalendarView() {

        doneBtn.isEnabled = false

        let screenWidth = UIScreen.main.bounds.width
        let weekView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: weekTitleView.frame.height))
        self.weekTitleView.addSubview(weekView)

        let weekWidth = screenWidth / 7

        let titles = [localizedStrings.localize(.sun),
            localizedStrings.localize(.mon),
            localizedStrings.localize(.tue),
            localizedStrings.localize(.wed),
            localizedStrings.localize(.thu),
            localizedStrings.localize(.fri),
            localizedStrings.localize(.sat),

        ]
        for i in 0..<7 {
            let week = UILabel(frame: CGRect(x: CGFloat(CGFloat(i) * weekWidth), y: 0, width: weekWidth, height: 44))
            week.textAlignment = .center
            weekView.addSubview(week)
            week.textColor = UIColor.kaoColor(.dustyGray2)
            week.font = UIFont.kaoFont(style: .semibold, size: 13)
            week.text = titles[i]
        }

        let calendarframe = calendarView.frame
        let frame = CGRect.init(x: calendarframe.x, y: calendarframe.y, width: screenWidth, height: calendarframe.size.height)

        calendarContentView = ZYCalendarView.init(frame: frame)
        calendarContentView.manager.maxDaysAllowedInRange = 0
        calendarContentView.manager.canSelectPastDays = true
        calendarContentView.manager.canSelectFutureDays = true
        calendarContentView.manager.selectionType = .range
        calendarContentView.manager.maxSelectPastMonths = 24
        calendarContentView.manager.selectedBackgroundColor = UIColor .kaoColor(.crimson)
        calendarContentView.manager.disableTextColor = UIColor.lightGray
        calendarContentView.maxDate = Date()
        calendarContentView.dayViewBlock = dayViewCallBack

        if self.selectedDates.count == 2 {
            if let date = self.selectedDates.first {
                calendarContentView.selectedDate = date
                updateDateView(true, date: date)
            }

            if let date = self.selectedDates[safe: 1] {
                updateDateView(false, date: date)
            }
            updateDoneBtn(true)
        } else {
            calendarContentView.selectedDate = Date()
        }
        self.calendarContentView.manager.setSelectedDates(NSMutableArray.init(array: self.selectedDates))
        self.calendarView.addSubview(calendarContentView)
    }

    private func updateDateView(_ isStartDate: Bool, date: Date) {
        if isStartDate {
            startDateTitle.textColor = UIColor.kaoColor(.black)
            startDateView.isHidden = false
            startSelectDate.isHidden = true
            startDate.text = date.toString("d")
            startDayTitle.text = date.toString("EEEE")
            startMonthTitle.text = date.toString("MMM YYYY")
        } else {
            endDateTitle.textColor = UIColor.kaoColor(.black)
            endDateView.isHidden = false
            endSelectDate.isHidden = true
            endDate.text = date.toString("d")
            endDayTitle.text = date.toString("EEEE")
            endMonthTitle.text = date.toString("MMM YYYY")
        }
    }

    private func resetEndDate() {
        endDateView.isHidden = true
        endSelectDate.isHidden = false
        endDateTitle.text = localizedStrings.localize(.endDate)
        endSelectDate.text = localizedStrings.localize(.selectEndDate)
        endDateTitle.textColor = UIColor.kaoColor(.crimson)
    }

    private func resetStartDate() {
        startDateView.isHidden = true
        startSelectDate.isHidden = false
        startDateTitle.text = localizedStrings.localize(.startDate)
        startSelectDate.text = localizedStrings.localize(.selectStartDate)
        startDateTitle.textColor = UIColor.kaoColor(.crimson)
    }

    private func updateDoneBtn(_ isEnabled: Bool) {
        self.doneBtn.isEnabled = isEnabled
    }

    public func enableFutureDates(_ isEnabled: Bool) {
        self.calendarContentView.manager.canSelectFutureDays = isEnabled
    }

    // MARK: - Callbacks
    private func dayViewCallBack(manager: ZYCalendarManager?, dayDate: Any?) {

        if manager?.selectedDateArray.count == 1 {
            if let date = manager?.selectedDateArray.firstObject as? Date, selectedDates.count == 1, date == selectedDates.first {
                updateDateView(false, date: date)
                selectedDates.insert(date, at: 1)
                updateDoneBtn(true)
            } else {
                selectedDates.removeAll()
                if let startDate = manager?.selectedDateArray.firstObject as? Date {
                    updateDateView(true, date: startDate)
                    selectedDates.insert(startDate, at: 0)
                }
                resetEndDate()
                updateDoneBtn(false)
            }
        } else if manager?.selectedDateArray.count == 2 {
            if let endDate = manager?.selectedDateArray[1] as? Date {
                updateDateView(false, date: endDate)
                selectedDates.insert(endDate, at: 1)
            }
            updateDoneBtn(true)
        } else {
            selectedDates.removeAll()
        }
    }

    // MARK: - Actions
    @IBAction func resetTapped(_ sender: Any) {
        resetStartDate()
        resetEndDate()
        selectedDates = []
        calendarContentView.manager.resetCalendar()
        updateDoneBtn(false)
        resetDidTapped?()
    }

    @IBAction func doneTapped(_ sender: Any) {
        doneTapped?(selectedDates)
    }
}

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
