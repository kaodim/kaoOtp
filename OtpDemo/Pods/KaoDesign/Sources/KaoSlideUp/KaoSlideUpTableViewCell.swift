//
//  KaoSlideUpTableViewCell.swift
//  Pods
//
//  Created by Kelvin Tan on 8/1/19.
//

import UIKit

public class KaoSlideUpTableViewCell: UITableViewCell, NibLoadableView {

	@IBOutlet private weak var descriptionLabel: UILabel!
	@IBOutlet private weak var totalLabel: UILabel!
	@IBOutlet private weak var topDivider: UIView!

	override public func awakeFromNib() {
        super.awakeFromNib()
    }

	public func configure(_ description: String, _ total: String) {
		descriptionLabel.text = description
		totalLabel.text = total
	}

	public func hideTopDivider(_ hide: Bool = true) {
		topDivider.isHidden = hide
	}
}
