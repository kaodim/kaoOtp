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
    @IBOutlet private weak var countrySelectionView: OtpCountrySelectionView!
    @IBOutlet private weak var dropDownIcon: UIImageView!
    @IBOutlet private weak var phoneTextfield: UITextField!

    private var contentView: UIView!
    private var selectedCountry: CountryPhone! {
        didSet {
            countrySelectionView.configure(countryPhone: selectedCountry)
        }
    }
    var phoneExtensionAttr: CustomLabelAttributes = CustomLabelAttributes() {
        didSet {
            countrySelectionView.countryPhoneExtensionAttr = phoneExtensionAttr
        }
    }
    var phoneTextfieldAttr: CustomTextfieldAttributes! {
        didSet {
            phoneTextfield.font = phoneTextfieldAttr.font
            phoneTextfield.textColor = phoneTextfieldAttr.color
            phoneTextfield.placeholder = phoneTextfieldAttr.placeholder
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
    }

    func configure(text: String?) {
        phoneTextfield.text = text
    }
}
