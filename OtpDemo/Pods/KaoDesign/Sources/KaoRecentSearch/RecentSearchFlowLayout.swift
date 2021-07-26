//
//  RecentSearchFlowLayout.swift
//  Kaodim
//
//  Created by Kelvin Tan on 4/1/19.
//  Copyright © 2019 Kaodim Sdn Bhd. All rights reserved.
//

/*
Used for Recent Search to align collection view cell to left
 */

import UIKit

class RecentSearchFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 10

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 10.0
        self.sectionInset = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 0.0, right: 16.0)
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
