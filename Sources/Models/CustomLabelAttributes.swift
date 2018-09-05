//
//  CustomLabelAttributes.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

public struct CustomLabelAttributes {
    let font: UIFont
    let color: UIColor

    public init(font: UIFont = .systemFont(ofSize: 14), color: UIColor = .black) {
        self.font = font
        self.color = color
    }
}
