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
    public let icon: UIImage?
    public let phoneExtension: String
    public let displayCode: String

    public init(icon: UIImage?, phoneExtension: String, displayCode: String) {
        self.icon = icon
        self.phoneExtension = phoneExtension
        self.displayCode = displayCode
    }
}
