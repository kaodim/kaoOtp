//
//  RecentSearchCell.swift
//  Kaodim
//
//  Created by Kelvin Tan on 3/26/19.
//  Copyright © 2019 Kaodim Sdn Bhd. All rights reserved.
//

import UIKit
class RecentSearchCell: UICollectionViewCell, CollectionCellAutoLayout, NibLoadableView {

    @IBOutlet private weak var labelWidth: NSLayoutConstraint!
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    var cachedSize: CGSize?
    var itemTapped: ((_ text: String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.addCornerRadius(4)
        labelWidth.constant = UIScreen.main.bounds.width - (16 * 4)
    }

    func configure(_ title: String) {
        titleLabel.text = title
    }

    @IBAction func searchTapped(_ sender: Any) {
        itemTapped?(titleLabel.text ?? "")
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return preferredLayoutAttributes(layoutAttributes)
    }

}
