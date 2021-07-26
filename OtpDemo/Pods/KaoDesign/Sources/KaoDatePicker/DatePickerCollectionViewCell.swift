//
//  DatePickerCollectionViewCell.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 12/9/19.
//

import UIKit

class DatePickerCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var surchargeView: UIView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var surchargeLabel: UILabel!
    @IBOutlet private weak var surchargeIcon: UIImageView!

    private var hasSurcharge: Bool?
    private var isPostiveSurcharge: Bool?
    private var selectedState = false

    static let reuseIdentifier = "DatePickerCollectionViewCell"

    override func prepareForReuse() {
        isSelected(false)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        parentView.bringSubviewToFront(surchargeView)
        parentView.addCornerRadius(8)
        dateLabel.addCornerRadius(8)
    }

    public func configureDate(_ date: String) {
        hideDate(false)
        let hasZero = date.hasPrefix("0")
        dateLabel.text = hasZero ? String(date.dropFirst()) : date
    }

    public func configureSurcharge(_ surcharge: String, _ isPostiveSurcharge: Bool) {
        hideSurcharge(hide: false)
        self.isPostiveSurcharge = isPostiveSurcharge
        surchargeLabel.text = surcharge
    }

    public func hideDate(_ hide: Bool) {
        dateLabel.isHidden = hide
    }

    public func configureUnavailability(_ available: Bool) {
        dateLabel.textColor = selectedState ? .white : (available ? .black : UIColor.kaoColor(.unavailableGray))
    }

    public func hideSurcharge(hide: Bool) {
        hasSurcharge = !hide
        surchargeLabel.isHidden = hide
        surchargeIcon.isHidden = hide
    }

    public func isSelected(_ selected: Bool) {
        selectedState = selected
        dateLabel.textColor = selected ? .white : .black
        surchargeLabel.textColor = selected ? UIColor.kaoColor(.kaodimRed20) : UIColor.kaoColor(.dimGray)
        if let isPostiveSurcharge = isPostiveSurcharge {
            let unSelectedIcon = isPostiveSurcharge ? "surcharge_icon" : "rebate_arrow"
            let selectedIcon = isPostiveSurcharge ? "surcharge_icon_light" : "rebate_arrow_light"
            let icon = selected ? selectedIcon : unSelectedIcon
            surchargeIcon.image = UIImage.imageFromDesignIos(icon)
        }
        configureSelection(selected)
    }


    private func configureSelection(_ selected: Bool) {
        guard let hasSurcharge = hasSurcharge else { return }
        parentView.backgroundColor = selected ? UIColor.kaoColor(.kaodimBrand) : .clear
    }
}
