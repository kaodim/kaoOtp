//
//  UIButton+Extension.swift
//  KaoDesign
//
//  Created by augustius cokroe on 24/10/2018.
//

import Foundation

public extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }

    func imageToRight() {
         transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
         titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
         imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
     }
}

