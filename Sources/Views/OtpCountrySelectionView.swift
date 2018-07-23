//
//  OtpCountrySelectionView.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

class OtpCountrySelectionView: UIView {

    @IBOutlet private weak var countryImage: UIImageView!
    @IBOutlet private weak var countryPhoneExtension: UILabel!

    private var contentView: UIView!
    private var currentCountryPhone: CountryPhone! {
        didSet {
            countryImage.image = currentCountryPhone.icon
            countryPhoneExtension.text = currentCountryPhone.phoneExtension
        }
    }
    var countryPhoneExtensionAttr: CustomLabelAttributes! {
        didSet {
            countryPhoneExtension.font = countryPhoneExtensionAttr.font
            countryPhoneExtension.textColor = countryPhoneExtensionAttr.color
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
        let nib = UINib(nibName: "OtpCountrySelectionView", bundle: Bundle.main)
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
    }

    func configure(countryPhone: CountryPhone) {
        currentCountryPhone = countryPhone
    }
}
