//
//  NSAttributedString+Label.swift
//  KaoDesign
//
//  Created by Ramkrishna on 20/05/2020.
//

import Foundation

public extension NSMutableAttributedString {

    func kaoAttrString(_ color: UIColor = UIColor.kaoColor(.black), font: UIFont = .kaoFont(style: .regular, size: 15)) {
        let attributes = [NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color]
        let nsText = self.string as NSString
        self.addAttributes(attributes, range: NSMakeRange(0, nsText.length))
    }

    func linkAttribute(url: URL, _ color: UIColor = UIColor.kaoColor(.vividBlue), font: UIFont = .kaoFont(style: .regular, size: 14), range: NSRange? = nil) {

        let nsText = self.string as NSString
        var nsRange = range
        if nsRange == nil {
            nsRange = NSRange(location: 0, length: nsText.length)
        }

        guard let range = nsRange else { return }
        self.setAttributes([
                .link: url,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color], range: range)
    }

    func kaoGreenAttrString(font: UIFont = .kaoFont(style: .regular, size: 15)) {
        let attributes = [NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.malachite)]
        let nsText = self.string as NSString
        self.addAttributes(attributes, range: NSMakeRange(0, nsText.length))
    }

    func kaoPlaceHolderAttrString(font: UIFont = .kaoFont(style: .regular, size: 15)) {
        let attributes = [NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.dustyGray2)]
        let nsText = self.string as NSString
        self.addAttributes(attributes, range: NSMakeRange(0, nsText.length))
    }

    func kaoIconWithAttrString(_ icon: UIImage?,
        _ endText: String,
        _ font: UIFont = .kaoFont(style: .regular, size: 14),
        _ textColor: UIColor = UIColor.kaoColor(.dimGray),
        _ alighnment: NSTextAlignment = .center,
        _ imageHeight: CGFloat = 16) {

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alighnment
        let attachment = NSTextAttachment()
        attachment.image = icon
        attachment.setImageHeight(height: imageHeight)
        let attributes = [
            NSAttributedString.Key.paragraphStyle: paragraph,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor]

        let attachmentString = NSAttributedString(attachment: attachment)
        let nsText = self.string as NSString
        self.addAttributes(attributes, range: NSMakeRange(0, nsText.length))
        self.append(attachmentString)
        if !endText.isEmpty {
            let endAttrString = NSAttributedString(string: " \(endText)", attributes: attributes)
            self.append(endAttrString)
        }
    }

    func kaoAlignAttrString(_ alignment: NSTextAlignment = .center) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        let attributes = [
            NSAttributedString.Key.paragraphStyle: paragraph]
        let nsText = self.string as NSString
        self.addAttributes(attributes, range: NSMakeRange(0, nsText.length))
    }

    func kaoStrikeThroughAttrString(_ color: UIColor = UIColor.kaoColor(.textDisable), font: UIFont = .kaoFont(style: .regular, size: 15)) {
        let attributes =
            [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.baselineOffset: 1,
                NSAttributedString.Key.strikethroughColor: UIColor.kaoColor(.textDisable),
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color
            ] as [NSAttributedString.Key: Any]

        let nsText = self.string as NSString
        self.addAttributes(attributes, range: NSMakeRange(0, nsText.length))
    }

    func kaoHtmlFont(font: UIFont, color: UIColor? = nil) {
        beginEditing()
        self.enumerateAttribute(
                .font,
            in: NSRange(location: 0, length: self.length)
        ) { (value, range, stop) in

            if let f = value as? UIFont,
                let newFontDescriptor = f.fontDescriptor
                .withFamily(font.familyName)
                .withSymbolicTraits(f.fontDescriptor.symbolicTraits) {

                let newFont = UIFont(
                    descriptor: newFontDescriptor,
                    size: font.pointSize
                )
                removeAttribute(.font, range: range)
                addAttribute(.font, value: newFont, range: range)
                if let color = color {
                    removeAttribute(
                            .foregroundColor,
                        range: range
                    )
                    addAttribute(
                            .foregroundColor,
                        value: color,
                        range: range
                    )
                }
            }
        }
        endEditing()
    }
}
