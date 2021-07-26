//
//  PayOptionCell.swift
//  KaoDesign
//
//  Created by Augustius on 31/05/2019.
//

import Foundation

public class PayOptionCell: UITableViewCell, NibLoadableView, PayOptionProtocolCell {

    @IBOutlet private weak var checkIconView: UIView!
    @IBOutlet private weak var checkIcon: UIImageView!
    @IBOutlet private weak var titleLabel: KaoLabel!
    @IBOutlet private weak var messageLabel: KaoLabel!
    @IBOutlet private weak var seperatorLine: UIView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        configureSelected(false)
        titleLabel.font = UIFont.kaoFont(style: .medium, size: 16)
        messageLabel.font = UIFont.kaoFont(style: .regular, size: 15)
    }

    public func configure(_ title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }

    public func configureSelected(_ selected: Bool) {
        checkIcon.image = selected ? selectImage : unselectImage
    }

    public func hideCheckIcon(_ hide: Bool) {
        checkIconView.isHidden = hide
    }

    public func hideSeperator(_ hide: Bool) {
        seperatorLine.isHidden = hide
    }

    public static func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PayOptionProtocolCell {
        let cell: PayOptionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }

    public func configureEnabled(_ enabled: Bool) {
        if(enabled) {
            messageLabel.textColor = #colorLiteral(red: 0.2901674509, green: 0.29021433, blue: 0.2901572585, alpha: 1)
        } else {
            messageLabel.textColor = #colorLiteral(red: 0.6470007896, green: 0.6470960975, blue: 0.646979928, alpha: 1)
        }
    }

    public func configureIcon(_ enabled: Bool, _ icon: UIImage?, _ tag: String, _ toolTipMessage: String) {
        let  foregroundColor =  enabled ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.482308507, green: 0.4823814631, blue: 0.4822924733, alpha: 1)
        let font = UIFont.kaoFont(style: .semibold, size: 18)
              let text = titleLabel.text ?? ""
              let titleText = NSMutableAttributedString(string: text)
              let paragraph = NSMutableParagraphStyle.kaoDefaultParagraphStyle()
              titleText.addAttributes([
                  NSAttributedString.Key.font: font,
                  NSAttributedString.Key.paragraphStyle: paragraph,
                  NSAttributedString.Key.foregroundColor: foregroundColor
                  ], range: NSRange(location: 0, length: text.count))
              let imageSize = CGSize(width: icon?.size.width ?? 0, height: icon?.size.height ?? 0)
              let imagePoint = CGPoint(x: 0, y: font.descender)
              let attachment = NSTextAttachment()
              attachment.image = icon
              attachment.bounds = CGRect(origin: imagePoint, size: imageSize)
              let titleImage = NSMutableAttributedString.init(attachment: attachment)
              titleText.append(titleImage)

              titleLabel.attributedText = titleText
    }
}
