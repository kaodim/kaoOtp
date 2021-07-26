//
//  KaoPopupView.swift
//  KaoDesign
//
//  Created by User on 13/02/2019.
//

import Foundation
import UIKit

public class KaoPopupAction {
    let title: String
    let style: KaoButtonType

    public init(title: String, style: KaoButtonType) {
        self.title = title
        self.style = style
    }
}

public class KaoPopupView: UIView {

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private var message: UITextView!
    @IBOutlet private weak var firstButton: KaoButton!
    @IBOutlet private weak var secondButton: KaoButton!
    @IBOutlet private weak var iconHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var secondButtonConstraint: NSLayoutConstraint!

    private var contentView: UIView!
    public var firstButtonTapped: (() -> Void)?
    public var secondButtonTapped: (() -> Void)?

    public var linkTapped: ((_ url: URL) -> Void)?


    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoPopupView")
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
        cardView.addCornerRadius()
        message.textColor = .kaoColor(.greyishBrown)
        message.delegate = self
        message.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.vividBlue)]
    }


    public func configure(_ image: UIImage? = nil, messageText: NSAttributedString, firstKaoButton: KaoPopupAction? = nil, secondKaoButton: KaoPopupAction? = nil, imageHeight: CGFloat? = nil) {
        message.attributedText = messageText
        configureIcon(image, imageHeight: imageHeight)
        configureButton(kaoPopupButton: firstKaoButton, button: self.firstButton)
        configureButton(kaoPopupButton: secondKaoButton, button: self.secondButton)
    }

    private func configureIcon(_ image: UIImage?, imageHeight: CGFloat? = nil) {
        guard let image = image else { return }
        icon.isHidden = false
        icon.image = image

        if let height = imageHeight {
            iconHeight.constant = height
        } else {
            if image.size.width > icon.bounds.width {
                iconHeight.constant = image.size.height * (icon.bounds.width / image.size.width)
            } else {
                iconHeight.constant = 150
            }
        }
    }

    private func configureButton(kaoPopupButton: KaoPopupAction?, button: KaoButton) {
        if let popUpButton = kaoPopupButton {
            button.isHidden = false
            button.setTitle(popUpButton.title, for: .normal)
            button.configure(type: popUpButton.style, size: KaoFontSize.regular)
        } else {
            button.isHidden = true
        }
        button.reloadInputViews()
    }

    public func configureOrientation(axis: NSLayoutConstraint.Axis) {
        buttonStackView.axis = axis
        buttonStackView.addArrangedSubview(self.buttonStackView.subviews[0])
        secondButtonConstraint.isActive = false
    }

    @IBAction private func firstButtonTap() {
        firstButtonTapped?()
    }

    @IBAction private func secondButtonTap() {
        secondButtonTapped?()
    }
}

extension KaoPopupView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        self.linkTapped?(URL)
        return false
    }
}
