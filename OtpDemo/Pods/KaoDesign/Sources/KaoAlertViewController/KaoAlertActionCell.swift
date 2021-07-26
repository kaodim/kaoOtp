//
//  KaoAlertActionCell.swift
//  Kaodim
//
//  Created by Ramkrishna on 29/10/2019.
//  Copyright © 2019 Kaodim Sdn Bhd. All rights reserved.
//

import UIKit

class KaoAlertActionCell: UITableViewCell,NibLoadableView {

    var optionTapped:(() -> Void)?

    @IBOutlet private weak var optionTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        optionTitle?.font = UIFont.kaoFont(style: .medium, size: 18)
        optionTitle.textColor = UIColor.kaoColor(.vividBlue)
        selectionStyle = .none
    }

    public func configure(_ title: NSAttributedString) {
        optionTitle.attributedText = title
    }

}
