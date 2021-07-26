
//
//  UIDevice+Notch.swift
//  KaoDesign
//
//  Created by Ramkrishna Baddi on 12/12/18.
//
extension UIDevice {
    public var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
}
