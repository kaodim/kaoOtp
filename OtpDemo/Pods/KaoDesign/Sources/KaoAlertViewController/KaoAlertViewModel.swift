//
//  KaoAlertViewModel.swift
//  Kaodim
//
//  Created by Ramkrishna on 26/06/2019.
//  Copyright © 2019 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation

public struct KaoAlertOption {
    public var title: NSAttributedString
    public let handler: (() -> Void)?
    public var style: UIAlertAction.Style = .default

    public init(title: NSAttributedString, handler: (() -> Void)?) {
        self.title = title
        self.handler = handler
    }
}

class KaoAlertViewModel: TableViewModel {
    var actionItems = [KaoAlertOption]()
    var headerTitle: String?
    var footerTitle: String!
    public var cancelTapped: (() -> Void)?

    init(actionItems: [KaoAlertOption], headerTitle: String? = nil, footerTitle: String) {
        self.actionItems = actionItems
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }

    var contentHeight: CGFloat {
        let optionsCount: CGFloat = CGFloat(actionItems.count)
        let cellHeight: CGFloat = 61.5
        let headerHeight: CGFloat = ((headerTitle == nil) ? 0 : 47.0)
        let footerHeight: CGFloat = 70.0
        return ((cellHeight * optionsCount) + headerHeight + footerHeight)
    }

    var didSelectRow: ((_ completion: (() -> Void)?) -> Void)?

    private lazy var footerView: KaoAlertBottomFooterView = {
        let view = KaoAlertBottomFooterView()
        view.cancelTapped = cancelTapped
        view.configureTitle(title: footerTitle)
        return view
    }()

    func configure() {
        self.reloadView()
    }

    private func reloadView() {
        self.items = []
        let item = KaoAlertActionItem.init(actionItems, footerView, headerTitle)
        item.didSelectRow = didSelectRow
        self.items.append(item)
        self.dataConfigured?()
    }

}
