//
//  TextfieldViewParams.swift
//  OtpFlow
//
//  Created by augustius cokroe on 18/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation

public struct TextfieldViewParams {
    let text: String?
    var phoneExtensionAttr: CustomLabelAttributes
    var phoneTextfieldAttr: CustomTextfieldAttributes

    public init(text: String? = nil, phoneExtensionAttr: CustomLabelAttributes = CustomLabelAttributes(), phoneTextfieldAttr: CustomTextfieldAttributes = CustomTextfieldAttributes()) {
        self.text = text
        self.phoneExtensionAttr = phoneExtensionAttr
        self.phoneTextfieldAttr = phoneTextfieldAttr
    }
}
