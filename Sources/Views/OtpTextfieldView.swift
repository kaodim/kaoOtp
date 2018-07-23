//
//  OtpTextfieldView.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

class OtpTextfieldView: UIView {

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var countrySelectionContentView: UIView!
    @IBOutlet private weak var dropDownIcon: UIImageView!
    @IBOutlet private weak var phoneTextfield: UITextField!

    private lazy var otpCountrySelectionView: OtpCountrySelectionView = {
        let view = OtpCountrySelectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var contentView: UIView!
    private var selectedCountry: CountryPhone! {
        didSet {
            otpCountrySelectionView.configure(countryPhone: selectedCountry)
        }
    }

    var didTapShowList: (() -> Void)?
    var didChangedText: ((_ text: String?) -> Void)?
    var textfieldDelegate: UITextFieldDelegate? {
        didSet {
            phoneTextfield.delegate = textfieldDelegate
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UINib(nibName: "OtpTextfieldView", bundle: Bundle.main)
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
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(red:0.9, green:0.91, blue:0.91, alpha:1).cgColor
        countrySelectionContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCountryOption)))
        dropDownIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCountryOption)))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        countrySelectionContentView.addSubview(otpCountrySelectionView)
        NSLayoutConstraint.activate([
            otpCountrySelectionView.leadingAnchor.constraint(equalTo: countrySelectionContentView.leadingAnchor),
            otpCountrySelectionView.trailingAnchor.constraint(equalTo: countrySelectionContentView.trailingAnchor),
            otpCountrySelectionView.topAnchor.constraint(equalTo: countrySelectionContentView.topAnchor),
            otpCountrySelectionView.bottomAnchor.constraint(equalTo: countrySelectionContentView.bottomAnchor)
            ])
    }

    @IBAction private func textDidChanged(_ sender: UITextField) {
        didChangedText?(sender.text)
    }

    func configure(countryPhone: CountryPhone) {
        selectedCountry = countryPhone
    }

    func configure(params: TextfieldViewParams) {
        phoneTextfield.text = params.text
        otpCountrySelectionView.countryPhoneExtensionAttr = params.phoneExtensionAttr
        phoneTextfield.font = params.phoneTextfieldAttr.font
        phoneTextfield.textColor = params.phoneTextfieldAttr.color
        phoneTextfield.placeholder = params.phoneTextfieldAttr.placeholder
    }

    func configure(dropUpDownImage: UIImage?) {
        dropDownIcon.image = dropUpDownImage
    }

    func textfieldBecomeResponder() {
        phoneTextfield.becomeFirstResponder()
    }

    @objc func showCountryOption() {
        didTapShowList?()
    }
}
