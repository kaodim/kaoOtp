//
//  KaoSlideUpRadio.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 8/5/19.
//

import UIKit

public enum DateRangesPerformance: Equatable {
	case today, sevenDays, thirtyDays, customDays(String, String)
}

public extension DateRangesPerformance {
	static func allCases() -> [DateRangesPerformance] {
		return [.today, .sevenDays, .thirtyDays, .customDays("","")]
	}

	func getDate() -> [String] {
		let currentDateTime = Date()
		let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: currentDateTime)
		switch self {
		case .today:
			let today = date?.toString() ?? ""
			return [today]
		case .sevenDays:
			let today = date?.toString() ?? ""
			let last7Days = date?.getLast(from: -6).toString() ?? ""
			return [today, last7Days]
		case .thirtyDays:
			let today = date?.toString() ?? ""
			let last30Days = date?.getLast(from: -29).toString() ?? ""
			return [today, last30Days]
		case .customDays(let startStr, let endStr):
			return [startStr, endStr]
		}
	}

	static func ==(lhs: DateRangesPerformance, rhs: DateRangesPerformance) -> Bool {
		switch (lhs, rhs) {
		case (.sevenDays, .sevenDays), (.thirtyDays, .thirtyDays), (.today, .today):
			return true
		case (.customDays(_, _), .customDays(_, _)):
			return true
		default:
			return false
		}
	}
}

public class KaoSlideUpRadio: UIView {

	@IBOutlet private weak var buttonTitle: UIButton!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var tableView: UITableView!

	private var containerView: UIView!
	private var dateOptions: [DateRangesPerformance] = []
	public var selectedDate: Int? {
		didSet {
			tableView.reloadData()
		}
	}

	public var selectedRow: ((_ range: DateRangesPerformance) -> Void)?
	public var closeTapped: (() -> Void)?
	public var calendarTap: (() -> Void)?
	public var getTranslate: ((_ range: DateRangesPerformance) -> String)?

	// MARK: - init methods
	public init() {
		super.init(frame: CGRect.zero)
		setupViews()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupViews()
	}

	// MARK: - Setup UI
	private func setupViews() {
		containerView = loadViewFromNib()
		containerView.frame = frame
		containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(containerView)
	}

	private func loadViewFromNib() -> UIView {
		let nib = UIView.nibFromDesignIos("KaoSlideUpRadio")
		guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
			fatalError("Nib not found.")
		}
		return view
	}

	public func configureButton(_ text: String) {
		buttonTitle.setTitle(text, for: .normal)
	}

	public func configureTitle(_ text: String) {
		titleLabel.text = text
	}

	public func configureTableView(_ options: [DateRangesPerformance]) {
		tableView.registerFromDesignIos(KaoSlideUpRadioTableViewCell.self)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none
		dateOptions = options
	}

	private func updateSelectedIndex(_ index: Int) {
		selectedDate = index

		if index == dateOptions.count - 1 {
			calendarTap?()
		} else {
			selectedRow?(dateOptions[index])
		}
	}

	@IBAction func closeDidTapped() {
		closeTapped?()
	}
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension KaoSlideUpRadio: UITableViewDataSource {
	public func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dateOptions.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: KaoSlideUpRadioTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
		let currentIndex = indexPath.row
		let dates = dateOptions[indexPath.row]
		let selected = currentIndex == selectedDate

		cell.selectionStyle = .none
		cell.configureTitle(getTranslate?(dates) ?? "")
		cell.isSelected(selected)
		return cell
	}
}

extension KaoSlideUpRadio: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		updateSelectedIndex(indexPath.row)
		closeTapped?()
	}
}
