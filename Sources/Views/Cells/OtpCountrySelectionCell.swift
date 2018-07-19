//
//  OtpCountrySelectionCell.swift
//  OtpFlow
//
//  Created by augustius cokroe on 18/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

class OtpCountrySelectionCell: UITableViewCell {

    private lazy var otpCountrySelectionView: OtpCountrySelectionView = {
        let view = OtpCountrySelectionView()
        view.countryPhoneExtensionAttr = countryPhoneExtensionAttr
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var countryPhoneExtensionAttr: CustomLabelAttributes = CustomLabelAttributes()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        addSubview(otpCountrySelectionView)
        NSLayoutConstraint.activate([
            otpCountrySelectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            otpCountrySelectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 15),
            otpCountrySelectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 14),
            otpCountrySelectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(countryPhone: CountryPhone) {
        otpCountrySelectionView.configure(countryPhone: countryPhone)
    }
}
