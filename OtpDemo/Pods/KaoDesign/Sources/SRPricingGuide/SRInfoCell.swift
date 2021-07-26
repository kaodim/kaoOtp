//
//  SRInfoCell.swift
//  KaoDesign
//
//  Created by Augustius on 20/12/2019.
//

import Foundation

public class SRInfoCell: UITableViewCell, NibLoadableView {

    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var arrowIconView: UIImageView!
    @IBOutlet private weak var descLabel: KaoLabel!
    @IBOutlet private weak var iconViewLeadingConstraint: NSLayoutConstraint!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureViews()
    }

    private func configureViews() {
        descLabel.font = .kaoFont(style: .regular, size: 16)
        descLabel.textColor = .kaoColor(.black)
        arrowIconView.image = UIImage.imageFromDesignIos("ic_chevron")
    }

    public func configure(_ desc: String, icon: UIImage?) {
        descLabel.text = desc
        if icon == nil {
            iconViewLeadingConstraint.constant = 16
        } else {
            iconView.image = icon
        }

    }
}
