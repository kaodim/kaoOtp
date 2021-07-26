//
//  KaoBorderedTextField.swift
//  KaoDesign
//
//  Created by Ismail Sahak on 05/07/2021.
//

import Foundation
import MaterialComponents

public class KaoBorderedTextField: UIView {

    public var textField: MDCOutlinedTextField!

    @IBInspectable var placeHolder: String!
    @IBInspectable var value: String!
    @IBInspectable var primaryColor: UIColor! = .kaoColor(.vividBlue)
    public var changeHandler: ((String) -> Void)?

    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        textField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        setUpProperty()
    }
    
    public var text: String? {
        return textField.text
    }
    
    private let normalScheme: MDCContainerScheme = {
        let scheme = MDCContainerScheme()
        scheme.colorScheme.primaryColor = .kaoColor(.vividBlue)
        scheme.colorScheme.secondaryColor = .kaoColor(.borderGrey)
        scheme.colorScheme.errorColor = .kaoColor(.kaodimBrand)
        return scheme
    }()

    func setUpProperty() {
        //Change this properties to change the propperties of text
        textField = MDCOutlinedTextField(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        textField.font = .kaoFont(style: .regular, size: 16)
        textField.clearButtonMode = .whileEditing
        textField.applyTheme(withScheme: normalScheme)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        self.addSubview(textField)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        changeHandler?(textField.text ?? "")
    }
    
    public func initiateFirstResponder() {
        textField.becomeFirstResponder()
    }
    
    public func configure(_ data: KaoTextFieldInputData, _ delegate: KaoTextFieldInputDelegate?) {
        textField.label.text = data.placeHolder
        textField.autocapitalizationType = data.capitalizationType
        textField.keyboardType = data.keyboardType
        
        if let icon = data.leftIcon {
            let imageView = UIImageView(image: UIImage.imageFromDesignIos(icon))
            imageView.tintColor = UIColor.kaoColor(.grayChateau)
            textField.leadingViewMode = .always
            textField.leadingView = imageView
        }
        
        if data.isSecureTextEntry {
            textField.clearButtonMode = .never
            textField.isSecureTextEntry = true
            configurePasswordView(isSecure: true)
        }

        textField.sizeToFit()
    }
    
    private func configurePasswordView(isSecure: Bool) {
        let image = isSecure ? UIImage.imageFromDesignIos("icon_mini_hidepassword") : UIImage.imageFromDesignIos("icon_mini_showpassword")
        let rightIcon = UIImageView(image: image)
        rightIcon.tintColor = UIColor.kaoColor(.grayChateau)
        rightIcon.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPassword(tapGestureRecognizer:)))
        rightIcon.addGestureRecognizer(tapGestureRecognizer)
        
        textField.trailingViewMode = .always
        textField.trailingView = rightIcon
    }

    @objc func showPassword(tapGestureRecognizer: UITapGestureRecognizer) {
        textField.isSecureTextEntry.toggle()
        configurePasswordView(isSecure: textField.isSecureTextEntry)
    }

    public func setErrorMessage(errorMessage: String) {
        if !errorMessage.isEmpty {
            textField.applyErrorTheme(withScheme: normalScheme)
            textField.leadingAssistiveLabel.text = errorMessage
        } else {
            textField.applyTheme(withScheme: normalScheme)
            textField.leadingAssistiveLabel.text = ""
        }
    }
}
