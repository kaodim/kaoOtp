//
//  TimePickerCollectionViewCell.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 12/5/19.
//

import UIKit

class TimePickerCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "TimePickerCollectionViewCell"

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var surchargeView: UIView!
    @IBOutlet private weak var surchargeIcon: UIImageView!
    @IBOutlet private weak var surchargeLabel: UILabel!
    @IBOutlet private weak var surchargeViewHeight: NSLayoutConstraint!

    private var selectedState = false
    private var isPostiveSurcharge: Bool?

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.textColor = .black
        parentView.backgroundColor = .white
        parentView.addBorderLine(color: UIColor.kaoColor(.gainsboro))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        parentView.addBorderLine(color: UIColor.kaoColor(.gainsboro))
        parentView.addCornerRadius()
    }

    public func configureDate(_ date: String) {
        titleLabel.text = date.toDate()?.getTime("h:mma") ?? ""
    }

    public func configureAvailability(_ available: Bool) {
        titleLabel.textColor = selectedState ? .white : (available ? .black : UIColor.kaoColor(.unavailableGray))
    }

    public func disableSurcharge() {
        surchargeLabel.text = ""
        surchargeIcon.image = nil
        surchargeIcon.isHidden = true
    }

    public func configureSurcharge(_ price: String, _ isPostiveSurcharge: Bool) {
        hideSurchargeView(false)
        surchargeLabel.text = price
        surchargeIcon.isHidden = false
        self.isPostiveSurcharge = isPostiveSurcharge
        let unSelectedIcon = isPostiveSurcharge ? "surcharge_icon" : "rebate_arrow"
        surchargeIcon.image = UIImage.imageFromDesignIos(unSelectedIcon)
    }

    public func hideSurchargeView(_ isHidden: Bool) {
        surchargeViewHeight.constant = isHidden ? 0 : 20
    }

    public func configureSelected(_ hasSurcharge: Bool, _ isSelected: Bool) {
        selectedState = isSelected
        parentView.backgroundColor = isSelected ? UIColor.kaoColor(.kaodimBrand) : UIColor.white
        titleLabel.textColor = isSelected ? .white : .black
        parentView.addBorderLine(color: isSelected ? .clear : UIColor.kaoColor(.gainsboro))
        surchargeLabel.textColor = isSelected ? UIColor.kaoColor(.kaodimRed20) : UIColor.kaoColor(.dimGray)
        if let isPostiveSurcharge = isPostiveSurcharge {
            let unSelectedIcon = isPostiveSurcharge ? "surcharge_icon" : "rebate_arrow"
            let selectedIcon = isPostiveSurcharge ? "surcharge_icon_light" : "rebate_arrow_light"
            let surchargeImage = isSelected ? selectedIcon : unSelectedIcon
            let icon = !hasSurcharge ? "" : surchargeImage
            surchargeIcon.image = UIImage.imageFromDesignIos(icon)
        }
    }
}
