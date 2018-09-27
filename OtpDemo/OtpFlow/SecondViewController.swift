//
//  SecondViewController.swift
//  OtpFlow
//
//  Created by augustius cokroe on 19/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit
import KaoOtpFlow

class SecondViewController: PhoneVerifyingViewController {

    override func viewDidLoad() {
        super.phoneVerifyDelegate = self
        super.phoneVerifyDataSource = self
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.startResendTimer()
    }
}

extension SecondViewController: PhoneVerifyDataSource, PhoneVerifyDelegate {
    func editNumberAttributes(in view: PhoneVerifyingViewController) -> CustomButtonAttributes {
        let customFont: UIFont = .boldSystemFont(ofSize: 14)
        return CustomButtonAttributes(text: "Edit your phone number now", font: customFont, color: UIColor.blue, disableColor: UIColor(), disableText: "", highlightedColor: UIColor())
    }
    

    func headerViewText(in view: PhoneVerifyingViewController) -> HeaderViewParams {
        let titleAttr = CustomLabelAttributes(font: .boldSystemFont(ofSize: 20), color: .red)
        let phoneAttr = CustomLabelAttributes(font: .systemFont(ofSize: 14), color: .brown)
        let updateAttr = CustomLabelAttributes(font: .systemFont(ofSize: 14), color: .blue)
        return HeaderViewParams(title: "Verify your phone number", titleAttr: titleAttr, message: "Enter the 6-digit code sent to you at", messageAttr: CustomLabelAttributes(), phoneNumberText: "+601938301133", phoneNumberTextAttr: phoneAttr, updateNumberText: "", updateNumberTextAttr: CustomLabelAttributes())
    }

    func pinTextFieldAttribute(in view: PhoneVerifyingViewController) -> CustomTextfieldAttributes {
        return CustomTextfieldAttributes(font: .boldSystemFont(ofSize: 14), color: .blue, placeholder: "", lineColor: .blue, disableLineColor: .brown)
    }

    func resendButtonAttribute(in view: PhoneVerifyingViewController) -> CustomButtonAttributes {
        let customFont: UIFont = .boldSystemFont(ofSize: 14)
        return CustomButtonAttributes(text: "Resend code", font: customFont, color: .blue, disableColor: .lightGray, disableText: "Resend code in")
    }

    func bottomViewButtonText(in view: PhoneVerifyingViewController) -> CustomButtonAttributes {
        let customFont: UIFont = .boldSystemFont(ofSize: 14)
        return CustomButtonAttributes(text: "Verify number", font: customFont, color: .red, disableColor: .gray, disableText: "Verified?")
    }

    func resendCodeDelay(in view: PhoneVerifyingViewController) -> Int {
        return 30
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
