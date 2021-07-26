//
//  UITextView+Extension.swift
//  KaoDesign
//
//  Created by augustius cokroe on 14/02/2019.
//

import Foundation
import UIKit

public extension UITextView {

    func addPlaceholderText(_ text: String, textColor: UIColor = UIColor.kaoColor(.silver), position: CGPoint = CGPoint(x: 0, y: 0)) {
        if let placeholderLabel = self.placeholderLabel() {
            placeholderLabel.isHidden = false
        } else {

            let placeholderLabel = UILabel()
            placeholderLabel.font = self.font
            placeholderLabel.text = text
            placeholderLabel.textColor = textColor
            placeholderLabel.sizeToFit()
            placeholderLabel.tag = 99
            placeholderLabel.numberOfLines = 0
            placeholderLabel.isHidden = false
            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(placeholderLabel)

            placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
            placeholderLabel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
            placeholderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        }
    }

    func removePlaceholder() {
        viewWithTag(99)?.removeFromSuperview()
    }

    func placeholderLabel() -> UILabel? {
        for subview in self.subviews where subview.tag == 99 {
            return subview as? UILabel
        }
        return nil
    }
}
public extension UITextField {

    var clearButton: UIButton? {
        return value(forKey: "clearButton") as? UIButton ?? value(forKey: "_clearButton") as? UIButton
    }

    var clearButtonTintColor: UIColor? {
        get {
            return clearButton?.tintColor
        }
        set {
            let image = clearButton?.imageView?.image?.withRenderingMode(.alwaysTemplate)
            clearButton?.setImage(image, for: .normal)
            clearButton?.tintColor = newValue
        }
    }

    var clearButtonImage: UIImage? {
        get {
            return clearButton?.imageView?.image
        }
        set {
            clearButton?.imageView?.image = newValue
        }
    }
}
