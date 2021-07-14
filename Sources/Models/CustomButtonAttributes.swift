//
//  CustomButtonAttributes.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit
import KaoDesign

public struct CustomButtonAttributes {
    let text: String
    let font: UIFont
    let color: UIColor
    let disableColor: UIColor
    let disableText: String
    let highlightedColor: UIColor

    public init(text: String = "",
                font: UIFont = UIFont.kaoFont(style: .semibold, size: 16),
                color: UIColor = .kaoColor(.kaodimBrand),
                disableColor: UIColor = .kaoColor(.kaodimRed40),
                disableText: String = "",
                highlightedColor: UIColor = .white) {
        self.text = text
        self.font = font
        self.color = color
        self.disableColor = disableColor
        self.disableText = disableText
        self.highlightedColor = highlightedColor
    }
}
