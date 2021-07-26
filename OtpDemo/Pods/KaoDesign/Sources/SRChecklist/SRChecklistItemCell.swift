//
//  SRChecklistItemCell.swift
//  KaoDesign
//
//  Created by Augustius on 17/12/2019.
//

import Foundation

public class SRChecklistItemCell: UITableViewCell, NibLoadableView {

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var descLabel: KaoLabel!

    private let icon = UIImage.imageFromDesignIos("icon_mini_reactivated")?.withRenderingMode(.alwaysOriginal)

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureViews()
    }

    private func configureViews() {
        cardView.addCornerRadius(4)
        cardView.addBorderLine(color: .kaoColor(.veryLightPink))
        descLabel.font = .kaoFont(style: .regular, size: 16)
        descLabel.textColor = .kaoColor(.black)
        iconView.image = icon
    }

    public func configure(_ desc: String) {
        descLabel.text = desc
        descLabel.sizeToFit()
    }
}
