//
//  KaoIconAndTitleCell.swift
//  KaoDesign
//
//  Created by Ramkrishna on 21/05/2020.
//

import UIKit

open class KaoIconAndTitleCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    open override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        titleLabel.font = .kaoFont(style: .regular, size: 16)
        titleLabel.textColor = .kaoColor(.greyishBrown)
    }

    func configureData(_ item: IconAndTitleCellData) {
        icon.image = item.icon
        titleLabel.attributedText = item.title
        bottomConstraint.constant = 10
    }

    func configureFirstCell() {
        topConstraint.constant = 15
    }

    func configureLastCell() {
        bottomConstraint.constant = 15
    }
}
