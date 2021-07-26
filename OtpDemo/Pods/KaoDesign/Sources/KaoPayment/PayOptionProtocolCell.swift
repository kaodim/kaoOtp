//
//  PayOptionProtocolCell.swift
//  KaoDesign
//
//  Created by Augustius on 31/05/2019.
//

import Foundation

public protocol PayOptionProtocolCell: UITableViewCell {
    func configure(_ title: String, message: String)
    func configure(_ desc1: String?, desc2: String?)
    func configureIcon(_ enabled: Bool, _ icon: UIImage?, _ tag: String, _ toolTipMessage: String)
    func configureBankLogos(_ icon: UIImage?)
    func configureSelected(_ selected: Bool)
    func configurePaymentOptionSelected(paymentMethod: PayOptionItemModel)
    func hideCheckIcon(_ hide: Bool)
    func hideSeperator(_ hide: Bool)
    func configureEnabled(_ enabled: Bool)
    static func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PayOptionProtocolCell
}

public extension PayOptionProtocolCell {
    var unselectImage: UIImage? {
        return UIImage.imageFromDesignIos("form_selection_off")
    }

    var selectImage: UIImage? {
        return UIImage.imageFromDesignIos("form_selection_on")
    }

    func configure(_ desc1: String?, desc2: String?) { }

    func configureIcon(_ icon: UIImage?) { }

    func configureBankLogos(_ icon: UIImage?) { }

    func configurePaymentOptionSelected(paymentMethod: PayOptionItemModel) { }
}
