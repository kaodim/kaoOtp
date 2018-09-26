//
//  PhoneEnterProtocol.swift
//  OtpFlow
//
//  Created by augustius cokroe on 18/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

public protocol PhoneEnterDataSource: class {

    func supportedCountryPhones(in view: PhoneEnteringViewController) -> [CountryPhone]

    func selectedCountryPhone(in view: PhoneEnteringViewController) -> CountryPhone?

    func headerViewText(in view: PhoneEnteringViewController) -> HeaderViewParams

    func textFieldAttribute(in view: PhoneEnteringViewController) -> TextfieldViewParams

    func bottomViewButtonText(in view: PhoneEnteringViewController) -> CustomButtonAttributes

    func dropDownUpImages(in view: PhoneEnteringViewController) -> CustomDropUpDownImage
}

extension PhoneEnterDataSource {

    func dropDownUpImages(in view: PhoneEnteringViewController) -> CustomDropUpDownImage {
        return CustomDropUpDownImage()
    }
}

public protocol PhoneEnterDelegate: class {
    
    func nextButtonTapped(in view: PhoneEnteringViewController, phoneNumber: String, countryPhone: CountryPhone)
    
    func countryDidChange(in view: PhoneEnteringViewController, country: CountryPhone)
}


