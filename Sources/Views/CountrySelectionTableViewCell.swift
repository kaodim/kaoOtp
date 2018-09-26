//
//  CountrySelectionTableViewCell.swift
//  KaoOtpFlow
//
//  Created by Kelvin Tan on 9/25/18.
//

import UIKit

class CountrySelectionTableViewCell: UITableViewCell {

    private lazy var countryOptionsView: CountryOptionsView = {
        let view = CountryOptionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(countryOptionsView)
        NSLayoutConstraint.activate([
            countryOptionsView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            countryOptionsView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            countryOptionsView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            countryOptionsView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(data: CountryPhone) {
        countryOptionsView.configure(icon: data.icon, label: data.displayCode)
    }
    
}
