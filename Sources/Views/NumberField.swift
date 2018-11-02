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

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var countryLabel: UILabel!
    @IBOutlet weak private var flagImageView: UIImageView!
    @IBOutlet weak private var numberField: MFTextField!
    @IBOutlet weak private var selectionView: UIView!
    @IBOutlet weak private var dropIcon: UIImageView!

    
    var didChangedText: ((_ text: String?) -> Void)?
    var selectionViewDidSelect: (() -> Void)?
    var countryPhone: CountryPhone?
    var countryCode: String?
    var valueUpdate: ((_ value: String) -> Void)?
    
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
        valueUpdate = didChangedText
        
        dropIcon.isHidden = true
    }

    func configureView(with selectedCountry: CountryPhone?) {
        countryPhone = selectedCountry
        countryCode = selectedCountry?.phoneExtension
        flagImageView.image = selectedCountry?.icon 
        countryLabel.text = "\(selectedCountry?.phoneExtension ?? "")"
    }
    
    func configureTextFieldLabel(with title: CustomTextfieldAttributes){
        titleLabel.text = title.label
        titleLabel.font = title.labelFont
        numberField.tintColor = title.color
        numberField.textColor = title.color
        numberField.underlineColor = title.lineColor
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
    
    func setText(with text: CustomTextfieldAttributes) {
        numberField.text = text.label
    }
    
    func rightViewTextField() {
        numberField.rightViewMode = .always
        numberField.rightView = selectionView
    }

    
    func configure(dropUpDownImage: UIImage?) {
        dropIcon.image = dropUpDownImage
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
        UIView.setAnimationsEnabled(false)
    }
    
    @IBAction private func textFieldChanged(_ sender: UITextField) {
        didChangedText?(sender.text)
    }
}





