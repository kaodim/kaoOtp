//
//  JobDetailsListingViewModel.swift
//  KaoDesign
//
//  Created by Ramkrishna on 21/05/2020.
//

import Foundation


public struct IconAndTitleCellData {
    public var icon: UIImage?
    public var title: NSAttributedString

    public init(icon: UIImage?, title: NSAttributedString) {
        self.title = title
        self.icon = icon
    }
}

public struct JobDetailsCellData {
    var cellTitle: String
    public var cellItems: [IconAndTitleCellData]

    public init(cellTitle: String, cellItems: [IconAndTitleCellData]) {
        self.cellTitle = cellTitle
        self.cellItems = cellItems
    }
}

public struct JobDetailsListingData {
    var headerData: KaoSlideUpHeaderData
    var cellData: JobDetailsCellData

    public init(headerData: KaoSlideUpHeaderData, cellData: JobDetailsCellData) {
        self.headerData = headerData
        self.cellData = cellData
    }
}

class JobDetailsListingViewModel: TableViewModel {
    let jobDetailsData: JobDetailsListingData!

    init(_ jobDetailsData: JobDetailsListingData) {
        self.jobDetailsData = jobDetailsData
    }
}
