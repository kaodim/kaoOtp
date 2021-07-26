//
//  PayOptionItemModel.swift
//  KaoDesign
//
//  Created by Ismail Sahak on 20/05/2020.
//  Copyright © 2020 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation

public struct PayOptionItemModel {
    let iconUrl: String?
    let icon: UIImage?
    let name: String
    let isCard: Bool
    let isWideCard: Bool
    let last4: String?
    
    public init(iconUrl: String?, icon: UIImage?, name: String, isCard: Bool, isWideCard: Bool = false, last4: String?) {
        self.iconUrl = iconUrl
        self.icon = icon
        self.name = name
        self.isCard = isCard
        self.isWideCard = isWideCard
        self.last4 = last4
    }
}
