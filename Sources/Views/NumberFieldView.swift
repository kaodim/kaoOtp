//
//  NumberFieldView.swift
//  Kaodim
//
//  Created by Kelvin Tan on 9/18/18.
//  Copyright © 2018 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation
import MaterialTextField

class NumberFieldView: UIView {
    
    @IBOutlet weak private var flagImageView: UIImageView!
    @IBOutlet weak private var countryCodeLabel: UILabel!
    @IBOutlet weak private var numberField: MFTextField!
    @IBOutlet weak private var selectionView: UIView!
    
    @IBOutlet weak private var fieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var fieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var fieldHeightConstraint: NSLayoutConstraint!
    
    var selectionViewDidSelect: (() -> Void)?
    var updateValidationState: ((Credential,Bool) -> Void)?
    var selectedCountry: SelectionData?
    var countryPhone: CountryPhone?
    var countryCode: String?
    
    override func awakeFromNib() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickSelectionView))
        selectionView.addGestureRecognizer(tapGesture)
        numberField.delegate = self
        numberField.keyboardType = .numberPad
        numberField.textAlignment = .left
        numberField.addTarget(self, action: #selector(onTextEditingChange), for: .editingChanged)
        configureClearTextField()
    }
    
    func configureView(with selectedCountry: SelectionData?) {
        self.selectedCountry = selectedCountry
        self.countryCode = selectedCountry?.code
        flagImageView.image = UIImage(named: selectedCountry?.flag ?? "")
        countryCodeLabel.text = "(\(selectedCountry?.code ?? ""))"
        if (numberField.text ?? "").count >= 5 {
            updateValidationState?(.username, isValid(with: true))
        } else {
            numberField.setErrorMessage(errorMessage: "")
        }
    }
    
    func configureView(with selectedCountry: CountryPhone?) {
        countryPhone = selectedCountry
        countryCode = selectedCountry?.phoneExtension
        flagImageView.image = selectedCountry?.icon
        countryCodeLabel.text = "(\(selectedCountry?.phoneExtension ?? ""))"
        if (numberField.text ?? "").count >= 5 {
            updateValidationState?(.username, isValid(with: true))
        } else {
            numberField.setErrorMessage(errorMessage: "")
        }
    }
    
    func textfieldBecomeResponder() {
        numberField.becomeFirstResponder()
    }
    
    func getText() -> String? {
        return numberField.text
    }
    
    func emptyText() {
        numberField.text = nil
    }
    
    func setText(with text: String, country: CountryPhone) {
        numberField.text = text
        flagImageView.image = country.icon
        countryCodeLabel.text = country.phoneExtension
    }
    
    func rightViewTextField() {
        numberField.rightViewMode = .always
        numberField.rightView = selectionView
    }
    
    func configureClearTextField() {
        numberField.setUpClearTheme()
        fieldHeightConstraint.constant = 50
    }
    
    func configureField(mode: ViewMode) {
        if mode == .landing {
            fieldLeadingConstraint.constant = 15
            fieldTrailingConstraint.constant = 15
            fieldHeightConstraint.constant = 50
            numberField.setUpClearTheme()
        } else {
            fieldLeadingConstraint.constant = 0
            fieldTrailingConstraint.constant = 0
            fieldHeightConstraint.constant = 64
            numberField.setupCustomTheme(placeHolder: "Enter mobile number", type: .mobileNumber)
        }
    }
    
    func getNumberWithCode() -> String {
        let number = numberField.text?.first == "0" ? String(numberField.text?.dropFirst() ?? "") : (numberField.text ?? "")
        return (countryCode?.replacingOccurrences(of: "+", with: "") ?? "") + (number)
    }
    
    @objc func onClickSelectionView() {
        selectionViewDidSelect?()
    }
}

extension NumberFieldView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let mfTextFiled = (textField as? MFTextField)
        mfTextFiled?.setError(nil, animated: true)
    }
    
    @objc func onTextEditingChange(_ textField: UITextField) {
        
        if (textField.text ?? "").count >= 5 {
            updateValidationState?(.username, isValid(with: true))
        } else {
            numberField.setErrorMessage(errorMessage: "")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        updateValidationState?(.username, isValid(with: true))
    }
    
    func isValid(with error: Bool) -> Bool {
        let number = "\(countryCode ?? "")" + "\(numberField.text ?? "")"
        return Validator.shared.validateNumber(number: number, textField: numberField, setError: error)
    }
}

