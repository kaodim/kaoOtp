//
//  OtpPinTextfield.swift
//  OtpFlow
//
//  Created by augustius cokroe on 19/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

protocol OtpPinTextFieldDelegate : UITextFieldDelegate {
    func didPressBackspace(textField : OtpPinTextfield)
}

@IBDesignable
public class OtpPinTextfield: UITextField {

    @IBInspectable public var underLineWidth: CGFloat = 0.0 {
        didSet {
            updateUnderLineFrame()
        }
    }

    @IBInspectable public var underLineColor: UIColor = .groupTableViewBackground {
        didSet {
            updateUnderLineUI()
        }
    }

    private var underLineLayer = CALayer()

    override public func layoutSubviews() {
        super.layoutSubviews()
        applyUnderLine()
    }

    private func applyUnderLine() {
        // Apply underline only if the text view's has no borders
        if borderStyle == UITextBorderStyle.none {
            underLineLayer.removeFromSuperlayer()
            updateUnderLineFrame()
            updateUnderLineUI()
            layer.addSublayer(underLineLayer)
            layer.masksToBounds = true
        }
    }

    private func updateUnderLineFrame() {
        var rect = bounds
        rect.origin.y = bounds.height - underLineWidth
        rect.size.height = underLineWidth
        underLineLayer.frame = rect
    }

    private func updateUnderLineUI() {
        underLineLayer.backgroundColor = underLineColor.cgColor
    }

    override public func deleteBackward() {
        super.deleteBackward()

        // If conforming to our extension protocol
        if let pinDelegate = self.delegate as? OtpPinTextFieldDelegate, self.text == "" {
            pinDelegate.didPressBackspace(textField: self)
        }
    }
}
