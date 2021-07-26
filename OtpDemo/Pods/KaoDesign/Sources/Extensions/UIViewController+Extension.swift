//
//  UIViewController+Extension.swift
//  KaoDesign
//
//  Created by augustius cokroe on 25/10/2018.
//

import Foundation

public protocol vcBaseDependency: class {
    func startMapping() -> UIViewController
}

public protocol vcDependency: vcBaseDependency {
    associatedtype ViewController: UIViewController

    func getViewController() -> ViewController
}

public protocol vcvmDependency: vcDependency {
    associatedtype ViewModel: NSObject

    func getViewModel() -> ViewModel
}

public protocol vcvmdsDependency: vcvmDependency {
    associatedtype DataSource

    func getDataSource() -> DataSource
}

public extension UIViewController {

    // MARK: - Navigation Item
    // call below function on init
    func configureRightBarItem(_ icon: UIImage? = UIImage.imageFromDesignIos("ic_close_light")) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(dismissViewController))
    }

    func configureRightBarItem(_ title: String) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(dismissViewController))
    }

    func configureLeftBarItem(_ icon: UIImage? = UIImage.imageFromDesignIos("icon_mini_left")) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon, style: .done, target: self, action: #selector(popsViewController(_:)))
    }

    func configureLeftBarItem(_ title: String) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(popsViewController))
    }

    @objc func dismissViewController() {
        if let view = self as? KaoBaseViewController {
            view.rightBarTapped()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func popsViewController(_ sender: UIBarButtonItem) {
        if let view = self as? KaoBaseViewController {
            view.leftBarTapped(sender)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func mostTopOffset() -> CGFloat {
        let navHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let statusHeight = UIApplication.shared.statusBarView?.frame.height ?? 20
		let notchHeight: CGFloat = phoneHasNotch ? 24 : 0
        return navHeight + statusHeight + notchHeight
    }

    func pushVc(vcDependency: vcBaseDependency) -> UIViewController {
        let viewController = vcDependency.startMapping()
        navigationController?.pushViewController(viewController, animated: true)
        return viewController
    }

    func presentVc(vcDependency: vcBaseDependency) -> UIViewController {
        let viewController = vcDependency.startMapping()
        let navigation = KaoNavigationController(rootViewController: viewController)
        present(viewController, animated: true, completion: nil)
        return navigation
    }

    // MARK: - Component
    func kaoRefresher(action: Selector) -> UIRefreshControl {
        let position = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: 30)
        let refreshControl = UIRefreshControl(frame: CGRect(origin: position, size: CGSize(width: 20, height: 20)))
        refreshControl.addTarget(self, action: action, for: .valueChanged)
        return refreshControl
    }
}
