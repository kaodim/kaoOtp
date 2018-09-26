//
//  UITextfield+Custom.swift
//  KaoOtpFlow
//
//  Created by Kelvin Tan on 9/26/18.
//

import Foundation

public extension UITextField {
    @IBInspectable public var leftSpacer:CGFloat {
        get {
            if let left = leftView {
                return left.frame.size.width
            } else {
                return 0
            }
        } set {
            leftViewMode = .always
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
        }
    }
}
