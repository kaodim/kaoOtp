//
//  KaoBaseViewController.swift
//  Kaodim
//
//  Created by augustius cokroe on 13/11/2018.
//  Copyright © 2018 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

open class KaoBaseViewController: UIViewController, KaoNetworkProtocol {
    public var retry: (() -> Void)? = nil
    public var needListenToKeyboard: Bool = false
    public var hideTabbar: Bool = true

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialConfiguration()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialConfiguration()
    }

    open func initialConfiguration() {
        hidesBottomBarWhenPushed = hideTabbar
        navigationItem.backBarButtonItem = UIBarButtonItem.clearBackButton()
        navigationController?.navigationBar.kaodimStyle()
    }

    // MARK: - View cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .kaoColor(.veryLightPink)
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needListenToKeyboard {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if needListenToKeyboard {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    // MARK: - rightBar button action default function
    @objc open func rightBarTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - leftBar button action default function
    @objc open func leftBarTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Keyboard listener
    @objc open func keyboardWillShow(_ notification: Notification) { }

    @objc open func keyboardWillHide(_ notification: Notification) { }

    // MARK: - Layout animation
    public func animateLayout(duration: TimeInterval = 0.25) {
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - KaoNetworkProtocol
    open func addNetworkErrorView(_ errorView: UIView) {
        view.addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: safeTopAnchor),
            errorView.bottomAnchor.constraint(equalTo: safeBottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: safeLeadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: safeTrailingAnchor)
            ])
    }

    // MARK: - Override Present for xcode11
    override open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .overFullScreen
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
