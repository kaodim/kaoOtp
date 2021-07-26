//
//  SRChecklistViewModel.swift
//  KaoDesign
//
//  Created by Augustius on 17/12/2019.
//

import Foundation

protocol SRChecklistVMEventDelegate: BaseVMEventDelegate {
    func reloadSection(_ section: Int)
}

protocol SRChecklistProtocolItem: TableViewVMProtocol, Equatable { }

class SRChecklistViewModel: TableViewModel {

    private var checklists: [SRChecklist] = []

    private var vmEventDelegate: SRChecklistVMEventDelegate? {
        return eventDelegate as? SRChecklistVMEventDelegate
    }

    // MARK: - init methods
    init(_ checklists: [SRChecklist]) {
        super.init()
        self.checklists = checklists
        self.reloadView()
    }

    public func reloadItems<T: SRChecklistProtocolItem>(_ items: T) {
        if let index = self.items.firstIndex(where: {
            guard let currentItems = ($0 as? T) else { return false }
            return currentItems == items
        }) {
            vmEventDelegate?.reloadSection(index)
        }
    }

    private func reloadView() {
        checklists.forEach({
            let checklistItem = SRChecklistItem($0)
            checklistItem.eventDelegate = self
            self.items.append(checklistItem)
        })

        eventDelegate?.itemsConfigured()
    }
}

extension SRChecklistViewModel: SRChecklistItemEventDelegate {
    func reloadItem(_ item: SRChecklistItem) {
        reloadItems(item)
    }
}
