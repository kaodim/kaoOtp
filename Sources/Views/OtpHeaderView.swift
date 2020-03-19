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

        let combineStr = [headerViewParams.message, headerViewParams.phoneNumberText].joined(separator: " ")
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

    func configure(headerViewParams: HeaderViewParams) {
        if let title = headerViewParams.title{
            titleLabel.text = headerViewParams.title
            titleLabel.font = headerViewParams.titleAttr.font
            titleLabel.textColor = headerViewParams.titleAttr.color
            titleLabel.isHidden = false
        }else{
            titleLabel.isHidden = false
        }
        configureMessageLabel(headerViewParams: headerViewParams)
    }
}
