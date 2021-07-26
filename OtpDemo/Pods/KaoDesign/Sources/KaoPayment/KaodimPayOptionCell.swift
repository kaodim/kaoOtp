//
//  KaodimPayOptionCell.swift
//  KaoDesign
//
//  Created by Augustius on 31/05/2019.
//

import Foundation
import Kingfisher

public class KaodimPayOptionCell: UITableViewCell, NibLoadableView, PayOptionProtocolCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tagLabel: UILabel!

    @IBOutlet private weak var tagView: UIView!
    @IBOutlet private weak var checkIconView: UIView!
    @IBOutlet private weak var checkIcon: UIImageView!
    @IBOutlet private weak var seperatorLine: UIView!
    @IBOutlet private weak var desc1Label: UILabel!
    @IBOutlet private weak var desc2Label: UILabel!
    @IBOutlet private weak var bankLogos: UIImageView!
    @IBOutlet private weak var paymentOptionIcon: UIImageView!
    @IBOutlet private weak var paymentOptionName: KaoLabel!
    @IBOutlet private weak var paymentOptionIconConstraint: NSLayoutConstraint!
    @IBOutlet private weak var paymentOptionIconTrailing: NSLayoutConstraint!
    @IBOutlet private weak var paymentOptionIconWidth: NSLayoutConstraint!
    @IBOutlet private weak var descriptionView: UIView!
    @IBOutlet private weak var paymentOptionView: UIView!
    @IBOutlet private weak var bankLogoView: UIView!
    @IBOutlet private weak var selectPaymentView: UIView!
    @IBOutlet private weak var selectPaymentLabel: KaoLabel!

    private let defaultIconWidth: CGFloat = 32
    private let defaultTrailingSpace: CGFloat = 12
    private let cardIconWidth: CGFloat = 46
    private let twoCardsIconWidth: CGFloat = 100
    private let cardIconTrailingSpace: CGFloat = 8

    public var toolTipTap: ((_ message: String) -> Void)?

    override public func awakeFromNib() {
        super.awakeFromNib()
        configureSelected(false)
        let maxWidth = UIScreen.main.bounds.width - 108 //16+32+16+16+12+16
        desc1Label.preferredMaxLayoutWidth = maxWidth
        desc2Label.preferredMaxLayoutWidth = maxWidth
    }

    public func configure(_ title: String, message: String) {
        titleLabel.text = title
        paymentOptionView.isHidden = true
        selectPaymentView.isHidden = false
        descriptionView.isHidden = false
        selectPaymentLabel.font = .kaoFont(style: .regular, size: 15)
        selectPaymentLabel.textColor = .kaoColor(.dustyGray2)
        selectPaymentLabel.text = NSLocalizedString("select_a_payment_method", comment: "")
    }

    public func configure(_ desc1: String?, desc2: String?) {
        desc1Label.text = desc1
        desc2Label.text = desc2
    }

    public func configureIcon(_ enabled: Bool, _ icon: UIImage?, _ tag: String, _ toolTipMessage: String) {

        let font = UIFont.kaoFont(style: .semibold, size: 18)
        let text = titleLabel.text ?? ""
        let titleText = NSMutableAttributedString(string: text)
        let paragraph = NSMutableParagraphStyle.kaoDefaultParagraphStyle()
        titleText.addAttributes([
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: paragraph,
            NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.black)
            ], range: NSRange(location: 0, length: text.count))
        let imageSize = CGSize(width: icon?.size.width ?? 0, height: icon?.size.height ?? 0)
        let imagePoint = CGPoint(x: 0, y: font.descender)
        let attachment = NSTextAttachment()
        attachment.image = icon
        attachment.bounds = CGRect(origin: imagePoint, size: imageSize)
        let titleImage = NSMutableAttributedString.init(attachment: attachment)
        titleText.append(titleImage)

        if !(tag.isEmpty) {
            addTag(tag)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.toolTipTap?(toolTipMessage)
            }
        }
        titleLabel.attributedText = titleText
    }

    func addTag(_ tag: String) {
        let string = " \(tag) "
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.kaoColor(.crimson),
                .backgroundColor: UIColor.kaoColor(.kaodimRed10),
                .font: UIFont.kaoFont(style: .semibold, size: 12)
        ]

        let newTagAttrStr = NSAttributedString(string: string, attributes: attributes)
        tagLabel.attributedText = newTagAttrStr
    }

    public func configureBankLogos(_ icon: UIImage?) {
        bankLogos.image = icon
    }

    public func configureSelected(_ selected: Bool) {
        checkIcon.image = selected ? selectImage : unselectImage
    }

    public func configureEnabled(_ enabled: Bool) {

    }

    public func configurePaymentOptionSelected(paymentMethod payment: PayOptionItemModel) {
        descriptionView.isHidden = true
        selectPaymentView.isHidden = true
        paymentOptionView.isHidden = false
        paymentOptionName.font = .kaoFont(style: .regular, size: 15)
        paymentOptionName.textColor = .kaoColor(.black)
        paymentOptionName.text = payment.name
        let url = payment.iconUrl ?? ""

        if payment.isCard {
            paymentOptionIconConstraint?.isActive = false
            paymentOptionIconWidth.constant = payment.isWideCard ? twoCardsIconWidth : cardIconWidth
            paymentOptionIconTrailing.constant = cardIconTrailingSpace

            if let image = payment.icon {
                self.paymentOptionIcon.image = image
            }
            
            if let last4 = payment.last4, !last4.isEmpty {
                self.paymentOptionName.text = "•••• •••• •••• \(last4)"
            }
        }
        else {
            paymentOptionIconWidth.constant = defaultIconWidth
            paymentOptionIconTrailing.constant = defaultTrailingSpace
            paymentOptionIconConstraint?.isActive = true
        }

        contentView.layoutIfNeeded()

        if !url.isEmpty {
            paymentOptionIcon.cache(withURL: url, placeholder: nil)
        }
    }
    
    public func hideCheckIcon(_ hide: Bool) {
        checkIconView.isHidden = hide
    }

    public func hideSeperator(_ hide: Bool) {
        seperatorLine.isHidden = hide
    }

    public func getTagView() -> UIView {
        return tagView
    }

    public static func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PayOptionProtocolCell {
        let cell: KaodimPayOptionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
}
