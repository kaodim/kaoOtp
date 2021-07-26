//
//  KaoSlideUpRadioTableViewCell.swift
//  Pods
//
//  Created by Kelvin Tan on 8/5/19.
//

import UIKit

class KaoSlideUpRadioTableViewCell: UITableViewCell, NibLoadableView {

	@IBOutlet private weak var iconButton: UIButton!
	@IBOutlet private weak var titleLabel: UILabel!

	
	override func awakeFromNib() {
        super.awakeFromNib()
    }

	public func configureTitle(_ text: String) {
		titleLabel.text = text
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}

	public func isSelected(_ selected: Bool) {
		setSelected(selected, animated: false)
		let image = UIImage.imageFromDesignIos(selected ? "slice_radio_on" : "slice_radio_off")
		iconButton.setImage(image, for: .normal)
	}
}
