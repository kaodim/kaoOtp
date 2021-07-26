//
//  UINavigation+Extension.swift
//  KaoDesign
//
//  Created by augustius cokroe on 22/11/2018.
//

import Foundation

public struct KaoSearchBarParam {
    public var leadingConstant: CGFloat!
    public var placeholder: String!
    public var cancelTitle: String!

    public init() {
        self.leadingConstant = 15.0
        self.placeholder = NSLocalizedString("search", comment: "")
        self.cancelTitle = NSLocalizedString("cancel_text", comment: "")
    }
}

public extension UINavigationBar {
    func kaodimStyle() {
        /// Navigation bar content
        let backIcon = UIImage.imageFromDesignIos("icon_mini_left")
        backIndicatorImage = backIcon
        backIndicatorTransitionMaskImage = backIcon
        isTranslucent = false
        barTintColor = .white
        tintColor = .black
        titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.black),
            NSAttributedString.Key.font: UIFont.kaoFont(style: .semibold, size: .large)
        ]
        /// Bottom line
        shadowImage = UIColor.kaoColor(.whiteLilac).as1ptImage()
        setBackgroundImage(UIImage(), for: .default)
        layer.shadowColor = UIColor.clear.cgColor
    }
}

public extension UINavigationController {
    func showBottomLine(_ show: Bool = true) {
        if show {
            navigationBar.shadowImage = UIColor.kaoColor(.whiteLilac).as1ptImage()
        } else {
            navigationBar.shadowImage = UIImage()
        }
    }

    func currentSearchBar() -> UISearchBar? {
        return navigationBar.viewWithTag(999) as? UISearchBar
    }

    func showSearchBar(searchBarDelegate: UISearchBarDelegate? = nil, extraParam: KaoSearchBarParam = KaoSearchBarParam()) -> UISearchBar {
        var searchBar: UISearchBar!
        if let previousSearchBar = currentSearchBar() {
            searchBar = previousSearchBar
            if let constraint = (searchBar.constraints.filter { $0.firstAttribute == .leading }.first) {
                constraint.constant = extraParam.leadingConstant
            }
        } else {
            searchBar = UISearchBar.kaoDefault()
            searchBar.placeholder = extraParam.placeholder
            searchBar.setValue(extraParam.cancelTitle, forKey: "cancelButtonText")
            searchBar.tag = 999
            navigationBar.addSubview(searchBar)
            NSLayoutConstraint.activate([
                searchBar.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -15.0),
                searchBar.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: extraParam.leadingConstant),
                searchBar.topAnchor.constraint(equalTo: navigationBar.topAnchor),
                searchBar.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
                ])
        }
        searchBar.delegate = searchBarDelegate
        searchBar.isHidden = false
        return searchBar
    }

    func hideSearchBar() {
        if let previousSearchBar = currentSearchBar() {
            previousSearchBar.isHidden = true
            previousSearchBar.resignFirstResponder()
        }
    }

    func setTransparentWhiteTintColorTitle(_ isTransparent: Bool = true) {
        navigationBar.isTranslucent = isTransparent
        navigationBar.tintColor = .white
        navigationBar.barStyle = .default
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    func setTransparentBlackTintColorTitle(_ isTransparent: Bool = true) {
        navigationBar.isTranslucent = isTransparent
        navigationBar.tintColor = .black
        navigationBar.barStyle = .default
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
}

public extension UIBarButtonItem {
    class func clearBackButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    }

    class func kaodimBackButton(target: Any?, action: Selector?) -> UIBarButtonItem {
        let backIcon = UIImage.imageFromDesignIos("icon_mini_left")
        return UIBarButtonItem(image: backIcon, style: .done, target: target, action: action)
    }
}
