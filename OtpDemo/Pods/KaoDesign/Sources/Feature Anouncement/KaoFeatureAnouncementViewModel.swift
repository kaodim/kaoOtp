//
//  KaoFeatureAnouncementViewModel.swift
//  KaoDesign
//
//  Created by Ramkrishna on 21/05/2020.
//

import Foundation

public struct KaoFeatureAnnouncementCellData {
    var text: NSAttributedString
    var buttonTitle: String

    public init(text: NSAttributedString,
        buttonTitle: String) {
        self.text = text
        self.buttonTitle = buttonTitle
    }
}

public struct KaoFeatureAnnouncementData {
    var cellData: KaoFeatureAnnouncementCellData
    var image: UIImage?
    var buttonTitle: String

    public init(image: UIImage?,
        cellData: KaoFeatureAnnouncementCellData,
        buttonTitle: String) {
        self.image = image
        self.cellData = cellData
        self.buttonTitle = buttonTitle
    }
}

public class KaoFeatureAnnouncementViewModel: TableViewModel {
    public let featureData: KaoFeatureAnnouncementData!
    var buttonTapped: (() -> Void)?

    public init(_ featureData: KaoFeatureAnnouncementData) {
        self.featureData = featureData
    }

    func reloadView() {
        self.items = []
        let item = KaoFeatureAnnouncementItem(featureData.cellData)
        item.buttonTapped = { [weak self] in
            self?.buttonTapped?()
        }
        self.items.append(item)
    }
}
