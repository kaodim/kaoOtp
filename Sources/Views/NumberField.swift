//
//  NumberField.swift
//  Kaodim
//
//  Created by Kelvin Tan on 9/18/18.
//  Copyright © 2018 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation
import MaterialTextField

class NumberField: UIView {

    @IBOutlet weak private var countryLabel: UILabel!
    @IBOutlet weak private var flagImageView: UIImageView!
    @IBOutlet weak private var numberField: MFTextField!
    @IBOutlet weak private var selectionView: UIView!
    
    @IBOutlet weak var fieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var fieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var fieldHeightConstraint: NSLayoutConstraint!
    
    var selectionViewDidSelect: (() -> Void)?
    var countryPhone: CountryPhone?
    var countryCode: String?
    private var contentView: UIView!

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
            nib = UINib(nibName: "NumberField", bundle: bundle)
        } else {
            nib = UINib(nibName: "NumberField", bundle: Bundle.main)
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickSelectionView))
        selectionView.addGestureRecognizer(tapGesture)
        numberField.delegate = self
        numberField.keyboardType = .numberPad
        numberField.textAlignment = .left
        configureClearTextField()
    }

    func configureView(with selectedCountry: CountryPhone?) {
        countryPhone = selectedCountry
        countryCode = selectedCountry?.phoneExtension
        flagImageView.image = selectedCountry?.icon 
        countryLabel.text = "\(selectedCountry?.phoneExtension ?? "")"
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
        countryLabel.text = country.phoneExtension
    }
    
    func rightViewTextField() {
        numberField.rightViewMode = .always
        numberField.rightView = selectionView
    }
    
    func configureClearTextField() {
        fieldHeightConstraint.constant = 50
    }
    

    func getNumberWithCode() -> String {
        let number = numberField.text?.first == "0" ? String(numberField.text?.dropFirst() ?? "") : (numberField.text ?? "")
        return (countryCode?.replacingOccurrences(of: "+", with: "") ?? "") + (number)
    }
    
    @objc func onClickSelectionView() {
        selectionViewDidSelect?()
    }
}

extension NumberField : UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        let mfTextFiled = (textField as? MFTextField)
        mfTextFiled?.setError(nil, animated: true)
    }
}





