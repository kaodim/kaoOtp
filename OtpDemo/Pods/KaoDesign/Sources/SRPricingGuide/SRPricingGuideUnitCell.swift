//
//  SRPricingGuideUnitCell.swift
//  KaoDesign
//
//  Created by Augustius on 17/12/2019.
//

import Foundation

public class SRPricingGuideUnitCell: UITableViewCell, NibLoadableView {

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var titleLabel: KaoLabel!
    @IBOutlet private weak var descLabel: KaoLabel!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureViews()
    }

    private func configureViews() {
        cardView.addCornerRadius(4)
        cardView.addBorderLine(color: .kaoColor(.veryLightPink))
        titleLabel.font = .kaoFont(style: .medium, size: 15)
        titleLabel.textColor = .kaoColor(.dimGray)
        descLabel.font = .kaoFont(style: .medium, size: 15)
        descLabel.textColor = .kaoColor(.dimGray)
    }

    public func configure(_ title: String, desc: String) {
        titleLabel.text = title
        descLabel.text = desc
    }
}
