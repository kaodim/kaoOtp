//
//  CardPaymentMethodCell.swift
//  KaoDesign
//
//  Created by Ismail Sahak on 22/05/2020.
//

import Foundation

public class CardPaymentMethodCell: UITableViewCell, NibLoadableView {
   
    @IBOutlet private weak var radioButtonIcon: UIImageView!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var label: KaoLabel!
    @IBOutlet private weak var iconWidthConstraint: NSLayoutConstraint!
    
    private let defaultCardWidth: CGFloat = 46
    private let twoCardsWidth: CGFloat = 102
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
        iconWidthConstraint.constant = defaultCardWidth
        contentView.layoutIfNeeded()
    }
    
    public func configure(labelText: String, iconUrl: String, placeholderIcon: String) {
        let placeholder = UIImage.imageFromDesignIos(placeholderIcon)
        self.icon.cache(withURL: iconUrl, placeholder: placeholder)
        self.label.text = labelText
    }
    
    public func configureCardDetails(icon: UIImage, last4: String) {
        self.icon.image = icon
        self.label.text = "•••• •••• •••• \(last4)"
    }
    
    public func configureTwoCardsIcon() {
        iconWidthConstraint.constant = twoCardsWidth
        contentView.layoutIfNeeded()
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
