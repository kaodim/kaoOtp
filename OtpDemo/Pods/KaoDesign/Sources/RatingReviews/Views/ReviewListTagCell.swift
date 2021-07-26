//
//  ReviewListTagCell.swift
//  KaoDesign
//
//  Created by augustius cokroe on 17/04/2019.
//

import Foundation

class ReviewListTagCell: UICollectionViewCell, CollectionCellAutoLayout {

    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var tagView: UIView!
    @IBOutlet private weak var tagLabel: KaoLabel!
    @IBOutlet private weak var cardViewMaxWidth: NSLayoutConstraint!

    var cachedSize: CGSize?

    override func awakeFromNib() {
        super.awakeFromNib()
        icon.makeRoundCorner()
        tagView.addCornerRadius(18)
		tagView.addBorderLine(width: 1.0, color: UIColor.kaoColor(.veryLightPink))
        tagLabel.font = UIFont.kaoFont(style: .regular, size: 13)
        cardViewMaxWidth.constant = UIScreen.main.bounds.width - 104 //16+56+16+16
    }

    func configure(_ iconUrl: String, text: String) {
		let placeholder = UIImage.imageFromDesignIos("request-default")
		icon.cache(withURL: iconUrl, placeholder: placeholder)

        tagLabel.text = text

        self.contentView.setNeedsLayout()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return preferredLayoutAttributes(layoutAttributes)
    }
}
