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

    func selectedCountryPhone(in view: PhoneEnteringViewController) -> CountryPhone?

    func headerViewText(in view: PhoneEnteringViewController) -> HeaderViewParams

    func textFieldAttribute(in view: PhoneEnteringViewController) -> CustomTextfieldAttributes

    func bottomViewButtonText(in view: PhoneEnteringViewController) -> CustomButtonAttributes
    
    func textFieldValue(in view: PhoneEnteringViewController) -> CustomTextfieldAttributes
}

public protocol PhoneEnterDelegate: class {

    func nextButtonTapped(in view: PhoneEnteringViewController, phoneNumber: String, countryPhone: CountryPhone)
}


