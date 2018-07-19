//
//  PhoneVerifyProtocol.swift
//  OtpFlow
//
//  Created by augustius cokroe on 19/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation

import UIKit

protocol PhoneVerifyDataSource: class {

    func headerViewText(in view: PhoneVerifyingViewController) -> HeaderViewParams

    func pinTextFieldAttribute(in view: PhoneVerifyingViewController) -> CustomTextfieldAttributes

    func resendButtonAttribute(in view: PhoneVerifyingViewController) -> CustomButtonAttributes

    func bottomViewButtonText(in view: PhoneVerifyingViewController) -> CustomButtonAttributes
}

protocol PhoneVerifyDelegate: class {

    func verifyTapped(in view: PhoneVerifyingViewController, pins: String)

    func resendCodeTapped(in view: PhoneVerifyingViewController)

    func changeNumberTapped(in view: PhoneVerifyingViewController)
}
