//
//  KaoSlideUp.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 8/1/19.
//

import UIKit

public struct PerformanceData {
	public let score: Double
	public let scoreText: String
	public let type: String
	public let imageType: PercentageType
	public let percentage: Double?
	public let percentageText: String?
	public let positiveIncrease: Bool

	public init(score: Double, scoreText: String, type: String, imageType: PercentageType, percentage: Double?, percentageText: String?, positiveIncrease: Bool) {
		self.score = score
		self.scoreText = scoreText
		self.type = type
		self.imageType = imageType
		self.percentage = percentage
		self.percentageText = percentageText
		self.positiveIncrease = positiveIncrease
	}
}

extension PerformanceData {
	public func isFake() -> Bool {
		return score < 0
	}

	public func isError() -> Bool {
		return type == "error"
	}
}

public enum FormType {
	case withTableView, noTableView
}

public struct DataTable {
	public let description: String
	public let total: String

	public init(description: String, total: String) {
		self.description = description
		self.total = total
	}
}

public enum PercentageType: String {
	case redUp = "ic_trend_up_red"
	case redDown = "ic_trend_down_red"
	case greenUp = "ic_trend_up_green"
	case greenDown = "ic_trend_down_green"
}

open class KaoSlideUp: UIView {

	@IBOutlet private weak var closeButton: UIButton!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var scoreLabel: UILabel!
	@IBOutlet private weak var typeLabel: UILabel!
	@IBOutlet private weak var percentageImage: UIImageView!
	@IBOutlet private weak var percentageLabel: UILabel!
	@IBOutlet private weak var descriptionView: UIView!
	@IBOutlet private weak var descriptionLabel: UILabel!
	@IBOutlet private weak var dataView: UIView!
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var tableViewHeight: NSLayoutConstraint!
	@IBOutlet private weak var footerView: UIView!
	@IBOutlet private weak var footerDescription: UILabel!
	@IBOutlet private weak var icon: UIImageView!

	private var containerView: UIView!
	private var dataTable: [DataTable] = []

	var formType: FormType = .noTableView
	public var closeTapped: (() -> Void)?
	public var footerTapped: (() -> Void)?

	// MARK: - init methods
	public override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		setupViews()
	}

	required public init?(coder aDecoder: NSCoder) {
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
		let nib = UIView.nibFromDesignIos("KaoSlideUp")
		guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
			fatalError("Nib not found.")
		}
		return view
	}

	public func configureTitle(_ title: String) {
		titleLabel.text = title
	}

	public func configureCloseButton(_ text: String) {
		closeButton.setTitle(text, for: .normal)
	}

	public func configurePerformance(_ performance: PerformanceData) {
		if !(performance.score < 0) {
			scoreLabel.text = performance.scoreText
			typeLabel.text = performance.type
			percentageImage.image = UIImage.imageFromDesignIos(performance.imageType.rawValue)
			handlePercentageLabel(performance.percentage, positiveIncrease: performance.positiveIncrease)
		} else {
			self.startShimmerOnMainThread()
		}
	}

	private func handlePercentageLabel(_ percentage: Double?, positiveIncrease: Bool) {
		percentageImage.isHidden = true
		percentageLabel.isHidden = true
		if let percentage = percentage {
			percentageLabel.text = ("\(abs(percentage))%")
			percentageLabel.textColor = UIColor.handlePercentageColor(percentage, positiveIncrease: positiveIncrease)
			percentageImage.isHidden = false
			percentageLabel.isHidden = false

			if percentage == 0.0 {
				percentageImage.isHidden = true
			}
		}
	}

	public func configureType(_ type: FormType) {
		formType = type
		switch type {
		case .noTableView:
			descriptionView.isHidden = false
			dataView.isHidden = true
			footerView.isHidden = true
		case .withTableView:
			descriptionView.isHidden = true
			dataView.isHidden = false
			footerView.isHidden = false
		}
	}

	public func configureDescription(_ text: String) {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = 4

        let descriptionAttributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.paragraphStyle: paragraphStyle
		]

		let attributedString = NSMutableAttributedString(string: text)
		attributedString.addAttributes(descriptionAttributes, range: NSRange(location: 0, length: text.count))

		descriptionLabel.attributedText = attributedString
		descriptionLabel.textAlignment = .center
	}

	public func configureTableView(_ data: [DataTable]) {
		tableView.registerFromDesignIos(KaoSlideUpTableViewCell.self)
		tableView.dataSource = self
		tableView.removeFooterView()
		tableView.allowsSelection = false
		tableView.separatorStyle = .none
		tableView.isScrollEnabled = false
		dataTable = data
	}

	public func configureTableViewHeight(_ height: CGFloat) {
		tableViewHeight.constant = height >= 450 ? 450 : height
	}

	public func configureTableScrollable(_ scrollable: Bool) {
		tableView.isScrollEnabled = scrollable
	}

	public func configureFooterLabel(_ text: String) {
		footerView.isHidden = false
		footerDescription.text = text
	}

	public func configureFooterDescription(_ text: String) {
		configureFooterLabel(text)
		footerDescription.textColor = UIColor.kaoColor(.greyishBrown)
		footerDescription.font = UIFont.systemFont(ofSize: 15, weight: .regular)
		footerDescription.textAlignment = .center
		icon.isHidden = true
	}

	@IBAction func closeDidTapped() {
		closeTapped?()
	}

	@IBAction func footerDidTapped() {
		footerTapped?()
	}
}

extension KaoSlideUp: UITableViewDataSource {
	public func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataTable.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: KaoSlideUpTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
		let data = dataTable[indexPath.row]
		cell.configure(data.description, data.total)
		cell.hideTopDivider(indexPath.row != 0)
		return cell
	}
}

extension UIColor {
	public static func handlePercentageColor(_ percentage: Double, positiveIncrease: Bool) -> UIColor {
		var color: UIColor!
		if positiveIncrease {
			color = percentage < 0 ? UIColor.kaoColor(.errorRed) : UIColor.kaoColor(.malachite)
		} else {
			color = percentage < 0 ? UIColor.kaoColor(.malachite) : UIColor.kaoColor(.errorRed)
		}

		if percentage == 0.0 {
			color = UIColor.kaoColor(.dustyGray2)
		}

		return color
	}
}
