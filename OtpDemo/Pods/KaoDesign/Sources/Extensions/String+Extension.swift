//
//  String+Extension.swift
//  KaoDesign
//
//  Created by augustius cokroe on 09/11/2018.
//

import Foundation

public extension String {

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)

        if self.contains("\n") {
            let seperateTexts = self.components(separatedBy: "\n")
            let heights = seperateTexts.map({ (text) -> CGFloat in
                let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
                return ceil(boundingBox.height)
            })
            let totalHeight = heights.reduce(0, +)
            return totalHeight
        } else {
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
            return ceil(boundingBox.height)
        }
    }
}
