//
//  CustomTextfieldAttributes.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

public struct CustomTextfieldAttributes {
    let label: String
    let enabled: Bool
    let labelFont: UIFont
    let font: UIFont
    let color: UIColor
    let placeholder: String
    let placeholderColor: UIColor
    let lineColor: UIColor
    let disableLineColor: UIColor
    

    public init(label: String = "",
                enabled: Bool = true,
                labelFont: UIFont = .systemFont(ofSize: 14),
                font: UIFont = .systemFont(ofSize: 14),
                color: UIColor = .black,
                placeholder: String = "",
                placeholderColor: UIColor = .lightGray,
                lineColor: UIColor = .black,
                disableLineColor: UIColor = .lightGray) {
        self.label = label
        self.enabled = enabled
        self.labelFont = labelFont
        self.font = font
        self.color = color
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
        self.lineColor = lineColor
        self.disableLineColor = disableLineColor
    }
}
