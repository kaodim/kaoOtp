//
//  HeaderViewParams.swift
//  OtpFlow
//
//  Created by augustius cokroe on 18/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

public struct HeaderViewParams {
    let title: String
    let titleAttr: CustomLabelAttributes
    let message: String
    let messageAttr: CustomLabelAttributes
    let phoneNumberText: String
    let phoneNumberTextAttr: CustomLabelAttributes

    public init(title: String = "",
                titleAttr: CustomLabelAttributes = CustomLabelAttributes(),
                message: String = "",
                messageAttr: CustomLabelAttributes = CustomLabelAttributes() ,
                phoneNumberText: String = "",
                phoneNumberTextAttr: CustomLabelAttributes = CustomLabelAttributes()) {
        self.title = title
        self.titleAttr = titleAttr
        self.message = message
        self.messageAttr = messageAttr
        self.phoneNumberText = phoneNumberText
        self.phoneNumberTextAttr = phoneNumberTextAttr
    }
}
