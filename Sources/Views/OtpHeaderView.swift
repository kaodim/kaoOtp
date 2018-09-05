//
//  OtpHeaderView.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

class OtpHeaderView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    private var contentView: UIView!
    private var layoutManager: NSLayoutManager!
    private var textContainer: NSTextContainer!
    private var textStorage: NSTextStorage!
    private var clickableRange: NSRange!

    var didTapUpdateNumber: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib:UINib!
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "OtpCustomPod", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) {
            nib = UINib(nibName: "OtpHeaderView", bundle: bundle)
        } else {
            nib = UINib(nibName: "OtpHeaderView", bundle: Bundle.main)
        }
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    private func configureViews() {
        contentView = loadFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = messageLabel.bounds.size
    }

    private func configureMessageLabel(headerViewParams: HeaderViewParams) {
        messageLabel.font = headerViewParams.messageAttr.font
        messageLabel.textColor = headerViewParams.messageAttr.color

        let combineStr = [headerViewParams.message, headerViewParams.phoneNumberText, headerViewParams.updateNumberText].joined(separator: " ")
        let attrString = NSMutableAttributedString(string: combineStr)

        // phone number
        if headerViewParams.phoneNumberText != "" {
            let phoneRange = NSMakeRange(headerViewParams.message.count+1, headerViewParams.phoneNumberText.count)
            let phoneAttr: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey.foregroundColor : headerViewParams.phoneNumberTextAttr.color,
                NSAttributedStringKey.font : headerViewParams.phoneNumberTextAttr.font
            ]
            attrString.addAttributes(phoneAttr, range: phoneRange)
        }

        // update phone number
        if headerViewParams.updateNumberText != "" {
            clickableRange = NSMakeRange(combineStr.count-headerViewParams.updateNumberText.count, headerViewParams.updateNumberText.count)
            let updatePhoneAttr: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey.foregroundColor : headerViewParams.updateNumberTextAttr.color,
                NSAttributedStringKey.font : headerViewParams.updateNumberTextAttr.font
            ]
            attrString.addAttributes(updatePhoneAttr, range: clickableRange)
            messageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapLabel(_:))))
        }

        messageLabel.attributedText = attrString
        messageLabel.isUserInteractionEnabled = true

        layoutManager = NSLayoutManager()
        textContainer = NSTextContainer()
        textStorage = NSTextStorage(attributedString: attrString)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = messageLabel.lineBreakMode
        textContainer.maximumNumberOfLines = messageLabel.numberOfLines
    }

    @objc private func handleTapLabel(_ tapGesture: UITapGestureRecognizer) {
        let locationOfTouchInLabel = tapGesture.location(in: tapGesture.view)
        let labelSize = tapGesture.view?.bounds.size
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (((labelSize?.width ?? 0) - textBoundingBox.size.width) * 0.5) - textBoundingBox.origin.x , y: (((labelSize?.height ?? 0) - textBoundingBox.size.height) * 0.5) - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if NSLocationInRange(indexOfCharacter, clickableRange) {
            didTapUpdateNumber?()
        }
    }

    func configure(headerViewParams: HeaderViewParams) {
        titleLabel.text = headerViewParams.title
        titleLabel.font = headerViewParams.titleAttr.font
        titleLabel.textColor = headerViewParams.titleAttr.color

        configureMessageLabel(headerViewParams: headerViewParams)
    }
}
