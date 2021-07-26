//
//  AddCardOptionCell.swift
//  KaoDesign
//
//  Created by Ismail Sahak on 06/05/2020.
//

import Foundation

public class AddCardOptionCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: KaoLabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        label.font = UIFont.kaoFont(style: .medium, size: 16)
        label.textColor = UIColor.kaoColor(.vividBlue)
        label.text = "Add card"
        icon.image = UIImage.imageFromDesignIos("icon_to_add")
    }
}
