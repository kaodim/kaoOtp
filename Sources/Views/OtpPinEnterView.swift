//
//  OtpPinEnterView.swift
//  OtpFlow
//
//  Created by augustius cokroe on 19/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

class OtpPinEnterView: UIView {

    @IBOutlet private weak var pinStackviews: UIStackView!
    @IBOutlet private weak var resetButton: UIButton!

    private var contentView: UIView!
    private var resetButtonAttr = CustomButtonAttributes() {
        didSet {
            resetButton.titleLabel?.font = resetButtonAttr.font
        }
    }
    private var textfieldAttr = CustomTextfieldAttributes() {
        didSet {
            for view in pinStackviews.arrangedSubviews {
                guard let textfield = view as? OtpPinTextfield else { return }
                textfield.font = textfieldAttr.font
                textfield.textColor = textfieldAttr.color
                textfield.underLineColor = textfieldAttr.disableLineColor
            }
        }
    }

    var tapResend: (() -> Void)?
    var pinCompleted: ((_ pins:String) -> Void)?
    var pinReset: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UINib(nibName: "OtpPinEnterView", bundle: Bundle.main)
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
        configurePinTextfield()
    }

    private func configurePinTextfield() {
        pinStackviews.isUserInteractionEnabled = false
        for (index, view) in pinStackviews.arrangedSubviews.enumerated() {
            guard let textfield = view as? OtpPinTextfield else { return }
            textfield.text = ""
            textfield.tag = index + 1
            textfield.keyboardType = .numberPad
            textfield.becomeFirstResponder()
            textfield.delegate = self
        }
    }

    @IBAction private func didTapResend() {
        tapResend?()
    }

    private func verifyPinComplete() {
        var pins: String = ""
        for view in pinStackviews.arrangedSubviews {
            guard // extra checking moght not need it
                let textfield = view as? OtpPinTextfield,
                let text = textfield.text,
                !text.isEmpty
                else { return }

            pins.append(text)
        }
        pinCompleted?(pins)
    }

    func configure(customButtonAttributes: CustomButtonAttributes, textfieldAttribute: CustomTextfieldAttributes) {
        resetButton.setTitle(customButtonAttributes.text, for: .normal)
        resetButtonAttr = customButtonAttributes
        textfieldAttr = textfieldAttribute
    }

    func enableResetButton(enable: Bool = true) {
        resetButton.isUserInteractionEnabled = false
        resetButton.setTitle(enable ? resetButtonAttr.text : resetButtonAttr.disableText , for: .normal)
        resetButton.backgroundColor = enable ? resetButtonAttr.color : resetButtonAttr.disableColor
    }
}

extension OtpPinEnterView: UITextFieldDelegate, OtpPinTextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard
            CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)),
            let currentPinTextfield = textField as? OtpPinTextfield else {
                return false
        }
        currentPinTextfield.text = string
        currentPinTextfield.underLineColor = textfieldAttr.lineColor

        if string != "" { // to handle backpress
            guard
                let pinTextfield = pinStackviews.viewWithTag(textField.tag + 1) as? OtpPinTextfield
                else {
                    verifyPinComplete()
                    return false
            }
            pinTextfield.becomeFirstResponder()
        }
        return false
    }

    func didPressBackspace(textField: OtpPinTextfield) {
        guard let pinTextfield = pinStackviews.viewWithTag(textField.tag - 1) as? OtpPinTextfield else { return }
        textField.underLineColor = textfieldAttr.disableLineColor
        pinReset?()
        pinTextfield.text = ""
        pinTextfield.becomeFirstResponder()
    }

}
