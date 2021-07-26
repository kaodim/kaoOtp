//
//  NSTextAttachment+Extension.swift
//  KaoDesign
//
//  Created by Ramkrishna on 20/05/2020.
//

import Foundation

extension NSTextAttachment {
    public func setImageHeight(height: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height

        bounds = CGRect(x: bounds.origin.x, y: -3, width: ratio * height, height: height)
    }
}
