//
//  CountryPhone.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

public struct CountryPhone {
    let icon: UIImage
    let phoneExtension: String

    public init(icon: UIImage, phoneExtension: String) {
        self.icon = icon
        self.phoneExtension = phoneExtension
    }
}
