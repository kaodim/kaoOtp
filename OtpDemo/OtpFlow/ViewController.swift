//
//  ViewController.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import UIKit
import KaoOtpFlow

class ViewController: PhoneEnteringViewController {

    var list : [CountryPhone] = []

    override func viewDidLoad() {
        configureList()
        super.phoneEnterDataSource = self
        super.phoneEnterDelegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func configureList() {
        for index in 0...2 {
            let countryPhone = CountryPhone(icon: UIImage(named: "flag_my")!, phoneExtension: "(+6\(index))")
            list.append(countryPhone)
        }
    }

    private func presentSecondView() {
        let view = SecondViewController()
        navigationController?.pushViewController(view, animated: true)
    }
}

extension ViewController: PhoneEnterDelegate, PhoneEnterDataSource {

    func nextButtonTapped(in view: PhoneEnteringViewController, phoneNumber: String, countryPhone: CountryPhone) {
        print(countryPhone.phoneExtension + " " + phoneNumber)
        print("next please....")
        presentSecondView()
    }

    func supportedCountryPhones(in view: PhoneEnteringViewController) -> [CountryPhone] {
        return list
    }

    func selectedCountryPhone(in view: PhoneEnteringViewController) -> CountryPhone? {
        return list.first
    }

    func headerViewText(in view: PhoneEnteringViewController) -> HeaderViewParams {
        let titleAttr = CustomLabelAttributes(font: .boldSystemFont(ofSize: 20), color: .red)
        return HeaderViewParams(title: "Verify your phone number", titleAttr: titleAttr, message: "This is as part of our effort to provide a safe and secure service, we will send you a 6-digit code for verification.", messageAttr: CustomLabelAttributes(), phoneNumberText: "", phoneNumberTextAttr: CustomLabelAttributes(), updateNumberText: "", updateNumberTextAttr: CustomLabelAttributes())
    }

    func textFieldAttribute(in view: PhoneEnteringViewController) -> TextfieldViewParams {
        let phoneExtensionAttr = CustomLabelAttributes(font: .boldSystemFont(ofSize: 14), color: .red)
        let textfieldAttr = CustomTextfieldAttributes(font: .boldSystemFont(ofSize: 14), color: .blue, placeholder: "Enter phone number", lineColor: .clear, disableLineColor: .clear)
        return TextfieldViewParams(text: nil, phoneExtensionAttr: phoneExtensionAttr, phoneTextfieldAttr: textfieldAttr)
    }

    func bottomViewButtonText(in view: PhoneEnteringViewController) -> CustomButtonAttributes {
        let customFont: UIFont = .boldSystemFont(ofSize: 14)
        return CustomButtonAttributes(text: "NEXT", font: customFont, color: .red, disableColor: .gray, disableText: "NOPE")
    }

    func dropDownUpImages(in view: PhoneEnteringViewController) -> CustomDropUpDownImage {
        return CustomDropUpDownImage(dropUp: UIImage(named: "up"), dropDown: UIImage(named: "down"))
    }
}

