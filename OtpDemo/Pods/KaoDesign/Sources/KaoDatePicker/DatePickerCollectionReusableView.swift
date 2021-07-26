//
//  DatePickerCollectionReusableView.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 12/9/19.
//

import UIKit

class DatePickerCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var monthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    public func configureMonth(_ month: String) {
        monthLabel.text = month
    }
    
}
