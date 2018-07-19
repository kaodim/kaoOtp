//
//  SecondViewController.swift
//  OtpFlow
//
//  Created by augustius cokroe on 19/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: PhoneVerifyingViewController {

    override func viewDidLoad() {
        super.phoneVerifyDelegate = self
        super.phoneVerifyDataSource = self
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

extension SecondViewController: PhoneVerifyDataSource, PhoneVerifyDelegate {

    func headerViewText(in view: PhoneVerifyingViewController) -> HeaderViewParams {
        let titleAttr = CustomLabelAttributes(font: .boldSystemFont(ofSize: 20), color: .red)
        return HeaderViewParams(title: "Verify your phone number", titleAttr: titleAttr, message: "Enter the 6-digit code sent to you at +601938301133 Change you number", messageAttr: CustomLabelAttributes())
    }

    func pinTextFieldAttribute(in view: PhoneVerifyingViewController) -> CustomTextfieldAttributes {
        return CustomTextfieldAttributes(font: .boldSystemFont(ofSize: 14), color: .blue, placeholder: "", lineColor: .blue, disableLineColor: .brown)
    }

    func resendButtonAttribute(in view: PhoneVerifyingViewController) -> CustomButtonAttributes {
        return CustomButtonAttributes()
    }

    func bottomViewButtonText(in view: PhoneVerifyingViewController) -> CustomButtonAttributes {
        let customFont: UIFont = .boldSystemFont(ofSize: 14)
        return CustomButtonAttributes(text: "Verify number", font: customFont, color: .red, disableColor: .gray, disableText: "Verified?")
    }

    func verifyTapped(in view: PhoneVerifyingViewController, pins: String) {
        print("pins : \(pins)")
    }

    func resendCodeTapped(in view: PhoneVerifyingViewController) {
        print("resendCodeTapped")
    }

    func changeNumberTapped(in view: PhoneVerifyingViewController) {
        print("changeNumberTapped")
    }


}
