//
//  SRChecklistShowAllCell.swift
//  Kaodim
//
//  Created by Augustius on 27/12/2019.
//  Copyright © 2019 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation

public class SRChecklistShowAllCell: UITableViewCell, NibLoadableView {

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var titleLabel: KaoLabel!
    @IBOutlet private weak var iconView: UIImageView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        cardView.addCornerRadius(4)
        cardView.addBorderLine(color: .kaoColor(.veryLightPink))
        titleLabel.font = .kaoFont(style: .regular, size: 15)
        titleLabel.textColor = .kaoColor(.vividBlue)
    }
    
    func configureView(_ isExpanded: Bool, localizedStrings: KaoCalendarLocalize) {
        titleLabel.text = isExpanded ? localizedStrings.localize(.showLessItems) : localizedStrings.localize(.showAllItems)
        iconView.image = isExpanded ? UIImage.imageFromDesignIos("icon_chevron_link_up") : UIImage.imageFromDesignIos("icon_chevron_link_down")
    }
}
