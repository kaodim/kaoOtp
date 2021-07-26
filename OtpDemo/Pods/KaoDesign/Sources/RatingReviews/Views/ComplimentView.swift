//
//  ComplimentView.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 10/14/19.
//

import UIKit

class ComplimentView: UIView {

	private var containerView: UIView!
	@IBOutlet weak var parentView: UIView!
	@IBOutlet weak var complimentIcon: UIImageView!
	@IBOutlet weak var complimentLabel: UILabel!

	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		setupViews()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupViews()
	}

	private func setupViews() {
		containerView = loadViewFromNib()
		containerView.frame = bounds
		containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(containerView)
		configureView()
	}

	private func loadViewFromNib() -> UIView {
		let nib = UIView.nibFromDesignIos("ComplimentView")
		guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
			fatalError("ComplimentView not found.")
		}
		return view
	}

	private func configureView() {
		complimentIcon.makeRoundCorner()
		parentView.addCornerRadius(18)
		parentView.addBorderLine(width: 1.0, color: UIColor.kaoColor(.veryLightPink))
	}

	public func configureReview(_ image: String, reviewText: String) {
		complimentIcon.image = UIImage(named: image)
		complimentLabel.text = reviewText
	}
}
