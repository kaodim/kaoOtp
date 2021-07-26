//
//  SRPricingGuideViewModel.swift
//  KaoDesign
//
//  Created by Augustius on 19/12/2019.
//

import Foundation

class SRPricingGuideViewModel: TableViewModel {

    private var pricingGuides: [SRPricingGuide] = []

    // MARK: - init methods
    init(_ pricingGuides: [SRPricingGuide]) {
        super.init()
        self.pricingGuides = pricingGuides
        self.reloadView()
    }

    private func reloadView() {
        pricingGuides.forEach({
            let checklistItem = SRPricingGuideItem($0)
            self.items.append(checklistItem)
        })

        eventDelegate?.itemsConfigured()
    }
}
