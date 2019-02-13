//
//  ViewController.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import UIKit
import KaoOtp

class ViewController: PhoneEnteringViewController {

    var list : [CountryPhone] = []
    var number = "12345767890"

    override func viewDidLoad() {
        configureList()
        super.phoneEnterDataSource = self
        super.phoneEnterDelegate = self
        super.viewDidLoad()
        configureBottomButton(enable: false)
    }
    
    private func configureList() {
        for index in 0...2 {
            let countryPhone = CountryPhone(phoneExtension: "(+6\(index))")
            list.append(countryPhone)
        }
    }
    
    override func phoneTextChanged(_ text: String?) {
        if text?.count ?? 0 > 6 {
            configureBottomButton(enable: true)
        } else {
            configureBottomButton(enable: false)
        }
    }

    private func presentSecondView() {
        let view = SecondViewController()
        navigationController?.pushViewController(view, animated: true)
    }
}

extension ViewController: PhoneEnterDelegate, PhoneEnterDataSource {
    func nextEnabled(in view: PhoneEnteringViewController) -> Bool {
        if number.count > 10 {
            return true
        } else {
            return false
        }
    }
    
    func textFieldValue(in view: PhoneEnteringViewController) -> CustomTextfieldAttributes {
        return CustomTextfieldAttributes(label: number)
    }
    
    func nextButtonTapped(in view: PhoneEnteringViewController, phoneNumber: String, countryPhone: CountryPhone) {
        print(countryPhone.phoneExtension + " " + phoneNumber)
        print("next please....")
        
        presentSecondView()
    }

    func selectedCountryPhone(in view: PhoneEnteringViewController) -> CountryPhone? {
        return list.first
    }

    func headerViewText(in view: PhoneEnteringViewController) -> HeaderViewParams {
        let titleAttr = CustomLabelAttributes(font: .boldSystemFont(ofSize: 20), color: .red)
        return HeaderViewParams(title: "Verify your phone number", titleAttr: titleAttr, message: "This is as part of our effort to provide a safe and secure service, we will send you a 6-digit code for verification.", messageAttr: CustomLabelAttributes(), phoneNumberText: "", phoneNumberTextAttr: CustomLabelAttributes())
    }

    func textFieldAttribute(in view: PhoneEnteringViewController) -> CustomTextfieldAttributes {
        return CustomTextfieldAttributes(label: "Mobile number", color: UIColor.black, lineColor: UIColor.lightGray )
    }

    func bottomViewButtonText(in view: PhoneEnteringViewController) -> CustomButtonAttributes {
        let customFont: UIFont = .boldSystemFont(ofSize: 14)
        return CustomButtonAttributes(text: "NEXT", font: customFont, color: .red, disableColor: .gray, disableText: "NOPE")
    }
}
