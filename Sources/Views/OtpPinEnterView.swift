//
//  OtpPinEnterView.swift
//  OtpFlow
//
//  Created by augustius cokroe on 19/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit
import KaoDesign

class OtpPinEnterView: UIView {

    @IBOutlet private weak var pinStackviews: UIStackView!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var buttonOtpViaPhone: UIButton!
    @IBOutlet weak var btnEditPhoneNumber: UIButton!
    @IBOutlet weak var pinView: SVPinView!
    
    @IBOutlet weak var labelErrorMessage: UILabel!
    private var contentView: UIView!
    private var resetButtonAttr = CustomButtonAttributes()
    private var textfieldAttr = CustomTextfieldAttributes()

    private var buttonOtpViaPhoneAttr = CustomButtonAttributes(){
        didSet {
            let attributes = NSAttributedString(string: buttonOtpViaPhoneAttr.text,
                                                attributes: [
                                                    NSAttributedStringKey.foregroundColor: buttonOtpViaPhoneAttr.color,
                                                    NSAttributedStringKey.font: buttonOtpViaPhoneAttr.font])
            buttonOtpViaPhone.setAttributedTitle(attributes, for: .normal)
        }
    }

    var tapPhoneNumberChange: (() -> Void)?
    var tapOtpViaPhoneCall: (() -> Void)?
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
        let nib:UINib!
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "OtpCustomPod", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) {
            nib = UINib(nibName: "OtpPinEnterView", bundle: bundle)
        } else {
            nib = UINib(nibName: "OtpPinEnterView", bundle: Bundle.main)
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

        buttonOtpViaPhone.isHidden = true
        resetButton.setTitle("", for: .normal)
        btnEditPhoneNumber.isHidden = true
        
        pinView.pinLength = 6
        pinView.textColor = UIColor.kaoColor(.black)
        pinView.borderLineColor = UIColor.kaoColor(.dustyGray2)
        pinView.activeBorderLineColor = UIColor.kaoColor(.crimson)
        pinView.errorBorderLineColor = UIColor.kaoColor(.crimson)
        pinView.fieldBackgroundColor = UIColor.clear
        pinView.activeFieldBackgroundColor = UIColor.clear
        pinView.borderLineThickness = 1
        pinView.activeBorderLineThickness = 2
        pinView.shouldSecureText = false
        pinView.allowsWhitespaces = false
        pinView.becomeFirstResponderAtIndex = 0
        pinView.font = UIFont.systemFont(ofSize: 36,weight: .medium)

        pinView.didFinishCallback = { pin in

            self.labelErrorMessage.isHidden = true
            if(pin.isEmpty){
                self.pinReset?()
            }

            if(pin.count == self.pinView.pinLength){
                self.pinCompleted?(pin)
            }
        }

        pinView.didChangeCallback = { pin in
            
            self.labelErrorMessage.isHidden = true
            if(pin.isEmpty){
                self.pinReset?()
            }
        }
    }

    @IBAction func didTappedResend() {
        tapResend?()
        configureErrorMessage(message: " ")
        pinView.clearPin()
        pinReset?()
    }

    @IBAction func didTapOtpViaPhone(_ sender: Any) {
        tapOtpViaPhoneCall?()
        configureErrorMessage(message: " ")
        pinView.clearPin()
        pinReset?()
    }

    public func wrongOtpTyped(){
        pinView.becomeFirstResponderAtIndex = pinView.pinLength - 1
        pinView.wrongOtpTyped()
    }

    @IBAction func didTapChangePhoneNumber(_ sender: Any) {
        tapPhoneNumberChange?()
    }

    func configureErrorMessage(message: String){
        labelErrorMessage.text = message
        labelErrorMessage.isHidden = false
    }

    func configure(customButtonAttributes: CustomButtonAttributes, textfieldAttribute: CustomTextfieldAttributes, buttonOtpViaPhoneAttr: CustomButtonAttributes,buttonEditPhoneNumberAttr: CustomButtonAttributes) {
        resetButtonAttr = customButtonAttributes
        textfieldAttr = textfieldAttribute

        btnEditPhoneNumber.setAttributedTitle( NSAttributedString(string: buttonEditPhoneNumberAttr.text,
                                            attributes: [
                                                NSAttributedStringKey.foregroundColor: buttonEditPhoneNumberAttr.color,
                                                NSAttributedStringKey.font: buttonEditPhoneNumberAttr.font]), for: .normal)

        buttonOtpViaPhone.setAttributedTitle( NSAttributedString(string: buttonOtpViaPhoneAttr.text,
        attributes: [
            NSAttributedStringKey.foregroundColor: buttonOtpViaPhoneAttr.color,
            NSAttributedStringKey.font: buttonOtpViaPhoneAttr.font]), for: .normal)
        configureErrorMessage(message: " ")
        pinView.clearPin()
        pinReset?()
    }

    func enableResetButton(enable: Bool = true, countDownStr: String = "") {
        resetButton.isEnabled = enable
        let attributes = NSAttributedString(string: enable ? resetButtonAttr.text : (resetButtonAttr.disableText + " \(countDownStr)"),
                                            attributes: [
                                                NSAttributedStringKey.font: resetButtonAttr.font,
                                                NSAttributedStringKey.foregroundColor: enable ? resetButtonAttr.color : resetButtonAttr.disableColor
            ])
        resetButton.setAttributedTitle(attributes, for: .normal)

        buttonOtpViaPhone.isHidden = !enable

    }
}
