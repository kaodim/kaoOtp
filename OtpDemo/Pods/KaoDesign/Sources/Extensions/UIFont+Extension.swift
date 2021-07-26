//
//  UIFont+Extension.swift
//  KaodimIosDesign
//
//  Created by augustius cokroe on 23/07/2018.
//  Copyright © 2018 kaodim. All rights reserved.
//

import Foundation
import UIKit

public enum KaoFontSize: CGFloat {
    case xsmall = 10
    case small = 12
    case regular = 14
    case large = 16
    case title = 18
    case title1 = 20
    case title2 = 22
    case title3 = 24
    case title4 = 26
    case title5 = 28
}

public extension UIFont {

    class func kaoFont(style: UIFont.Weight, size: KaoFontSize) -> UIFont {
        return self.kaoFont(style: style, size: size.rawValue)
    }

    class func kaoFont(style: UIFont.Weight, size: CGFloat) -> UIFont {
        let font = UIFont.systemFont(ofSize: size, weight: style)
        return font
    }

    func kaoDescription() -> String {
        return "font-family: '\(self.familyName)', '\(self.fontName)'; font-size: \(self.pointSize)px; font-style: normal"
    }
}
