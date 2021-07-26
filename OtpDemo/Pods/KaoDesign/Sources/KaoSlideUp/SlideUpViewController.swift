//
//  KaoSlideUpViewController.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 8/1/19.
//

import UIKit

class SlideUpViewController: KaoSlideUpViewController {

	private lazy var slideUp: KaoSlideUp = {
		let view = KaoSlideUp()
		view.closeTapped = closeTapped
		view.configureCloseButton("Close")
		let performance = PerformanceData(score: 99, scoreText: "99.9%", type: "Acceptance Rate", imageType: .redUp, percentage: 23, percentageText: "23%", positiveIncrease: true)
		view.configurePerformance(performance)
		view.configureTitle("Acceptance Rate")
		view.configureDescription("The rate is calculated from the number of jobs you accepted over the total jobs you received. Maintain 80% rate and above to keep your Minted status on Kaodim.")
		view.configureTableView(data)
		view.configureFooterLabel("View Full Transaction History")
		view.footerTapped = footerTapped
		view.configureType(.withTableView)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	let data = [DataTable(description: "Air Cond Cleaning", total: "RM37,500"), DataTable(description: "House Cleaning", total: "RM10,000"), DataTable(description: "House Cleaning", total: "RM10,000"),DataTable(description: "Air Cond Cleaning", total: "RM37,500"), DataTable(description: "House Cleaning", total: "RM10,000"), DataTable(description: "House Cleaning", total: "RM10,000"),DataTable(description: "Air Cond Cleaning", total: "RM37,500"), DataTable(description: "House Cleaning", total: "RM10,000"), DataTable(description: "House Cleaning", total: "RM10,000")]


	// calculate height based on device
	var height: CGFloat = 220

	override func viewDidLoad() {
		super.presentView = slideUp
		super.viewDidLoad()
		slideUp.configureTableView(data)
	}

	override public func viewWillAppear(_ animated: Bool) {
		super.presentViewHeight = calculateHeight()
		super.viewWillAppear(animated)
	}

	// MARK: - Callbacks
	private func closeTapped() {
		self.dismissAnimation()
	}

	private func calculateHeight() -> CGFloat {
		let count = data.count
		let tableHeight = CGFloat(count * 47)
		let final = height + tableHeight
		let shouldScroll = count > 4
		slideUp.configureTableViewHeight(tableHeight)
		slideUp.configureTableScrollable(shouldScroll)
		super.allowScrollable = shouldScroll
		return final
	}

	private func footerTapped() {
		print("footer tapped")
	}
}

// MARK: - Extension
extension UIViewController {
	public func presentSlideUp() {
		let view = SlideUpViewController()
		view.modalPresentationStyle = .overFullScreen
		present(view, animated: false, completion: nil)
	}
}
