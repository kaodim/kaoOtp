//
//  UISearchBar+Extension.swift
//  KaoDesign
//
//  Created by augustius cokroe on 22/11/2018.
//

import Foundation

public extension UISearchBar {
    class func kaoDefault() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.setImage(UIImage(named: "icon_mini_search"), for: .search, state: .normal)
        searchBar.searchBarStyle = .minimal
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = .darkGray
            textfield.textAlignment = .left
            textfield.rightViewMode = .always
            textfield.clearButtonMode = .never
            textfield.font = .kaoFont(style: .regular, size: .regular)
            textfield.backgroundColor = UIColor.kaoColor(.veryLightPink)
            textfield.addCornerRadius(15)
        }

//        if let cancelBarButton = searchBar.value(forKey: "cancelBarButtonItem") as? UIBarButtonItem {
//            cancelBarButton.tintColor = .lightGray
//        }
        return searchBar
    }
}
