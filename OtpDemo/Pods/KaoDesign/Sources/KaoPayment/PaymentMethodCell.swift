//
//  PaymentMethodCell.swift
//  KaoDesign
//
//  Created by Ismail Sahak on 12/05/2020.
//

import Foundation

public class PaymentMethodCell: UITableViewCell, NibLoadableView {
    
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var label: KaoLabel!
    @IBOutlet private weak var radioButtonIcon: UIImageView!

    private let disabledAlpha: CGFloat = 0.5
    private let enabledAlpha: CGFloat = 1.0
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        label.font = UIFont.kaoFont(style: .regular, size: 15)
        label.textColor = UIColor.kaoColor(.black)
    }
    override public func prepareForReuse() {
        super.prepareForReuse()
        configureEnabled(true)
    }
    
    public func configure(labelText: String, iconUrl: String) {
        self.icon.cache(withURL: iconUrl, placeholder: nil)
        self.label.text = labelText
    }
    
    public func configureCard(icon: UIImage, last4: String) {
        self.icon.image = icon
        self.label.text = "•••• •••• •••• \(last4)"
    }
    
    public func configureEnabled(_ enabled: Bool) {
        self.label.isOpaque = enabled
        self.icon.isOpaque = enabled
        self.radioButtonIcon.isOpaque = enabled
        self.label.alpha = enabled ? enabledAlpha : disabledAlpha
        self.icon.alpha = enabled ? enabledAlpha : disabledAlpha
        self.radioButtonIcon.alpha = enabled ? enabledAlpha : disabledAlpha
    }
}
