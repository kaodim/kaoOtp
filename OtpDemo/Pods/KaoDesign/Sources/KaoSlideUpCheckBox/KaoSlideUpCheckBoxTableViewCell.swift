//
//  KaoSlideUpCheckBoxTableViewCell.swift
//  Pods
//
//  Created by Kelvin Tan on 8/5/19.
//

import UIKit

public class KaoSlideUpCheckBoxTableViewCell: UITableViewCell, NibLoadableView {

	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var iconButton: UIButton!

	override public func awakeFromNib() {
        super.awakeFromNib()
    }

	override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	public func configure(_ text: String, selected: Bool) {
		titleLabel.text = text
		configureSelected(selected)
	}

	public func configureSelected(_ selected: Bool) {
		let image = selected ? "slice_checkbox_on" : "slice_checkbox_off"
		iconButton.setImage(UIImage.imageFromDesignIos(image) , for: .normal)
	}
}
