//
//  SRPricingGuideUnitItemCell.swift
//  KaoDesign
//
//  Created by Augustius on 17/12/2019.
//

import Foundation

public class SRPricingGuideUnitItemCell: UITableViewCell, NibLoadableView {

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var titleLabel: KaoLabel!
    @IBOutlet private weak var descLabel: KaoLabel!
    @IBOutlet private weak var separatorTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var separator: UIView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureViews()
    }

    private func configureViews() {
        cardView.addCornerRadius(4)
        cardView.addBorderLine(color: .kaoColor(.veryLightPink))
        titleLabel.font = .kaoFont(style: .regular, size: 16)
        titleLabel.textColor = .kaoColor(.black)
        descLabel.font = .kaoFont(style: .regular, size: 16)
        descLabel.textColor = .kaoColor(.black)
    }

    public func configure(_ title: String, desc: String) {
        titleLabel.text = title
        descLabel.text = desc
    }
    
    public func showSeparator(isHidden: Bool) {
        separator.isHidden = isHidden
        separatorTopConstraint.constant = isHidden ? 0 : 12
        cardView.layoutIfNeeded()
    }
}
