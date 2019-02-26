//
//  KaoPopupView.swift
//  KaoDesign
//
//  Created by User on 13/02/2019.
//

import Foundation
import UIKit

public enum KaoPopupViewStyle {
    case normal, cancel
}

public class KaoPopupAction {
    let title: String
    let style: KaoPopupViewStyle

    public init(title: String, style: KaoPopupViewStyle) {
        self.title = title
        self.style = style
    }
}

public class KaoPopupView: UIView {

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var message: UILabel!
    @IBOutlet private weak var firstButton: KaoButton!
    @IBOutlet private weak var secondButton: KaoButton!
    @IBOutlet private weak var iconHeight: NSLayoutConstraint!

    private var contentView: UIView!
    public var dismissTapped: (() -> Void)?
    public var firstButtonTapped: (() -> Void)?
    public var secondButtonTapped: (() -> Void)?

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
    }

    public func configure(_ image: UIImage? = nil, messageText: NSAttributedString, firstKaoButton: KaoPopupAction? = nil, secondKaoButton: KaoPopupAction? = nil) {
        message.attributedText = messageText
        configureIcon(image)
        configureButton(kaoPopupButton: firstKaoButton, button: self.firstButton)
        configureButton(kaoPopupButton: secondKaoButton, button: self.secondButton)
        message.addLineSpacing(3)
    }

    private func configureIcon(_ image: UIImage?) {
        guard let image = image else { return }
        icon.isHidden = false
        icon.image = image
        if image.size.width > icon.bounds.width {
            iconHeight.constant = image.size.height * (icon.bounds.width / image.size.width)
        } else {
            iconHeight.constant = 150
        }
    }

    private func configureButton(kaoPopupButton: KaoPopupAction?, button: KaoButton) {
        if let title = kaoPopupButton?.title {
            button.isHidden = false
            button.setTitle(title, for: .normal)
        } else {
            button.isHidden = true
        }
        if let style = kaoPopupButton?.style, style == .normal {
            button.configure(type: .primary, size: KaoFontSize.regular)
        } else {
            button.configure(type: .dismiss, size: KaoFontSize.regular)
        }
        button.reloadInputViews()
    }


    @IBAction private func firstButtonTap() {
        firstButtonTapped?()
    }

    @IBAction private func secondButtonTap() {
        secondButtonTapped?()
    }
}
