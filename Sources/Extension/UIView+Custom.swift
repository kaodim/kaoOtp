//
//  UIView+Custom.swift
//  KaoOtpFlow
//
//  Created by Kelvin Tan on 9/25/18.
//

import UIKit

public extension UIView {
    
    class func loadFromNib() -> UIView? {
        return UINib(nibName: self.description(), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    class func loadFromNib(withIdentifier identifier: String) -> UIView? {
        return UINib(nibName: identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }

    func withCardView(shadowRadius radius: CGFloat? = 2.0, shadowColor: UIColor = UIColor.gray, shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0), shadowOpacity: Float = 0.8){
        clipsToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = (radius ?? 2.0 - 1.0)
        layer.cornerRadius = radius ?? 2.0
    }

    func dropShadow(shadowRadius radius: CGFloat? = 2.0, shadowColor: UIColor = UIColor.gray, shadowOffSet: CGSize = CGSize(width: 0.0, height: 1.0), shadowOpacity: Float = 0.8) {
        layer.cornerRadius = 4
        layer.shadowOffset = shadowOffSet
        layer.shadowOpacity = shadowOpacity

        layer.shadowRadius = (radius ?? 2.0 - 1.0)
        layer.masksToBounds = false
        layer.shadowPath = nil
        layer.borderColor = shadowColor.cgColor
        clipsToBounds = false
    }

    func addCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
