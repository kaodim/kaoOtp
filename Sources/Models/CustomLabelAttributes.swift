//
//  CustomLabelAttributes.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

struct CustomLabelAttributes {
    let font: UIFont
    let color: UIColor
}

extension CustomLabelAttributes {
    init() {
        self.font = .systemFont(ofSize: 14)
        self.color = .black
    }
}
