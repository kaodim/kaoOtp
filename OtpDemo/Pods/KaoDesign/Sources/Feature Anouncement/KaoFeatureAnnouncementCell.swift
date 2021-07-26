//
//  KaoFeatureAnnouncementCell.swift
//  KaoDesign
//
//  Created by Ramkrishna on 16/06/2020.
//

import UIKit

class KaoFeatureAnnouncementCell: UITableViewCell, NibLoadableView {

    @IBOutlet private weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightBtnIcon: UIImageView!
    @IBOutlet weak var buttonContentView: UIView!

    var buttonTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        label.textColor = UIColor.kaoColor(.vividBlue)
        label.font = UIFont.kaoFont(style: .medium, size: 15)
        rightBtnIcon.image = UIImage.imageFromDesignIos("icon_chevron_link_right")
        self.selectionStyle = .none
    }

    func confiureText(text: NSAttributedString, _ buttonText: String, _ buttonTapped: @escaping (() -> Void)) {
        self.textView.attributedText = text
        self.label.text = buttonText
        self.buttonTapped = buttonTapped
    }

    @IBAction func buttonTapped(_ sender: Any) {
        buttonTapped?()
    }

    public func hideButtonView() {
        self.buttonContentView.isHidden = true
    }
}
