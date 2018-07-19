//
//  CustomButtonAttributes.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

struct CustomButtonAttributes {
    let text: String
    let font: UIFont
    let color: UIColor
    let disableColor: UIColor
    let disableText: String
}

extension CustomButtonAttributes {
    init() {
        self.text = ""
        self.font = .systemFont(ofSize: 14)
        self.color = .red
        self.disableColor = .gray
        self.disableText = ""
    }
}
