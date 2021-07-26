//
//  KaoStatus.swift
//  KaoDesign
//
//  Created by Ramkrishna on 24/10/2019.
//

import Foundation

public class KaoStatus {
    var text: String
    var isSelected: Status
    var position: StatusPosition = .first
    public var icon: UIImage?
    public var borderColor: UIColor?

    public init(statusText: String, isSelected: Status = .unselected) {
        self.text = statusText
        self.isSelected = isSelected
    }
}
