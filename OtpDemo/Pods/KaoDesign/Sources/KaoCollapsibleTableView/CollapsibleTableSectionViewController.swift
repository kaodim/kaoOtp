//
//  CollapsibleTableSectionViewController.swift
//  KaoDesign
//
//  Created by Ismail Sahak on 05/05/2020.
//

import Foundation
import UIKit

//
// MARK: - CollapsibleTableSectionDelegate
//
@objc public protocol CollapsibleTableSectionDelegate {
    @objc optional func numberOfSections(_ tableView: UITableView) -> Int
    @objc optional func collapsibleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    @objc optional func collapsibleTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    @objc optional func collapsibleTableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    @objc optional func collapsibleTableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    @objc optional func collapsibleTableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    @objc optional func collapsibleTableView(_ tableView: UITableView, iconUrlForHeaderInSection section: Int) -> String?
    @objc optional func collapsibleTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    @objc optional func shouldCollapseByDefault(_ tableView: UITableView) -> Bool
    @objc optional func shouldCollapseOthers(_ tableView: UITableView) -> Bool
}

//
// MARK: - View Controller
//
open class CollapsibleTableSectionViewController: KaoBaseViewController {
    
    public var delegate: CollapsibleTableSectionDelegate?
    
    public var tableView: UITableView!
    fileprivate var sectionsState = [Int : Bool]()
    
    public func isSectionCollapsed(_ section: Int) -> Bool {
        if sectionsState.index(forKey: section) == nil {
            sectionsState[section] = delegate?.shouldCollapseByDefault?(tableView) ?? false
        }
        return sectionsState[section]!
    }
    
    func getSectionsNeedReload(_ section: Int) -> [Int] {
        var sectionsNeedReload = [section]
        
        // Toggle collapse
        let isCollapsed = !isSectionCollapsed(section)
        
        // Update the sections state
        sectionsState[section] = isCollapsed
        
        let shouldCollapseOthers = delegate?.shouldCollapseOthers?(tableView) ?? false
        
        if !isCollapsed && shouldCollapseOthers {
            // Find out which sections need to be collapsed
            let filteredSections = sectionsState.filter { !$0.value && $0.key != section }
            let sectionsNeedCollapse = filteredSections.map { $0.key }
            
            // Mark those sections as collapsed in the state
            for item in sectionsNeedCollapse { sectionsState[item] = true }
            
            // Update the sections that need to be redrawn
            sectionsNeedReload.append(contentsOf: sectionsNeedCollapse)
        }
        
        return sectionsNeedReload
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the tableView
        tableView = UITableView.kaoDefault(style: .grouped, delegate: self, dataSource: self)
        tableView.allowsMultipleSelection = false
        
        // Auto resizing the height of the cell
        tableView.backgroundColor = .kaoColor(.veryLightPink)
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 100, right: 0)
        
        // Auto layout the tableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
}

//
// MARK: - View Controller DataSource and Delegate
//
extension CollapsibleTableSectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return delegate?.numberOfSections?(tableView) ?? 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = delegate?.collapsibleTableView?(tableView, numberOfRowsInSection: section) ?? 0
        return isSectionCollapsed(section) ? 0 : numberOfRows
    }
    
    // Cell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return delegate?.collapsibleTableView?(tableView, cellForRowAt: indexPath) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DefaultCell")
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.collapsibleTableView?(tableView, didSelectRowAt: indexPath)
    }
    
    // Header
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = CollapsibleTableViewHeader()
        
        let title = delegate?.collapsibleTableView?(tableView, titleForHeaderInSection: section) ?? ""
        
        let iconUrl = delegate?.collapsibleTableView?(tableView, iconUrlForHeaderInSection: section) ?? ""
        
        header.configure(iconUrl: iconUrl, labelText: title)
        header.setCollapsed(isSectionCollapsed(section))
        header.section = section
        header.delegate = self
        
        return header
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegate?.collapsibleTableView?(tableView, heightForHeaderInSection: section) ?? 60.0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return delegate?.collapsibleTableView?(tableView, heightForFooterInSection: section) ?? 0.0
    }
    
}

//
// MARK: - Section Header Delegate
//
extension CollapsibleTableSectionViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ section: Int) {
        let sectionsNeedReload = getSectionsNeedReload(section)
        tableView.reloadSections(IndexSet(sectionsNeedReload), with: .automatic)
    }
    
}
