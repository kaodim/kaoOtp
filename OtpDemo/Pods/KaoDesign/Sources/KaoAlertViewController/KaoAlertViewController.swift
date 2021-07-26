//
//  KaoAlertViewController.swift
//  Kaodim
//
//  Created by augustius cokroe on 19/11/2018.
//  Copyright © 2018 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation

public class KaoAlertViewController: KaoBottomSheetController {

    // MARK: - Properties
    public lazy var tableView: UITableView = {
        let view = UITableView.kaoDefault(delegate: kaoAlertViewModel, dataSource: kaoAlertViewModel)
        view.registerFromDesignIos(KaoAlertActionCell.self)
        view.removeFooterView()
        view.separatorStyle = .none
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var kaoAlertViewModel: KaoAlertViewModel!
    private var kaoAlertActions = [KaoAlertOption]()

    // MARK: - init methods
   public init(_ kaoAlertActions: [KaoAlertOption], _ headerTitle: String? = nil, _ footerTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.kaoAlertActions = kaoAlertActions
        self.kaoAlertViewModel = KaoAlertViewModel(actionItems: kaoAlertActions, headerTitle: headerTitle, footerTitle: footerTitle)
        self.configureViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle
    public override func viewDidLoad() {
        super.presentView = tableView
        super.viewDidLoad()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.presentViewHeight = kaoAlertViewModel.contentHeight
        super.viewWillAppear(animated)

        let isScrollable = super.presentViewHeight > super.maxPresentHeight
        tableView.isScrollEnabled = isScrollable
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: isScrollable ? bottomOffset : 0)))
    }

    // MARK: - Class methods
    private func configureViewModel() {
        kaoAlertViewModel.dataConfigured = { [weak self] in self?.reloadTable()  }
        kaoAlertViewModel.cancelTapped = { [weak self] in self?.cancelTapped() }
        kaoAlertViewModel.didSelectRow = { [weak self] completion in self?.dismissHandler(completion) }
        kaoAlertViewModel.configure()
    }

    // MARK: - Callback
    private func reloadTable() {
        self.tableView.reloadData()
    }

    func dismissHandler(_ completion: (() -> Void)? = nil) {
        self.dismissAnimation {
            completion?()
        }
    }

    private func cancelTapped() {
        self.dismissAnimation()
    }
}

extension UIViewController {
    public func presentKaoAlertVC(_ kaoAlertActions: [KaoAlertOption], _ headerTitle: String? = nil, _ footerTitle: String) {
//        let view = KaoAlertViewController(kaoAlertActions, headerTitle, footerTitle)
//        view.modalPresentationStyle = .overFullScreen
//        present(view, animated: false, completion: nil)

        let alert = UIAlertController(title: headerTitle, message: "", preferredStyle: .actionSheet)

        kaoAlertActions.forEach { (action) in
            alert.addAction(UIAlertAction(title: action.title.string, style: action.style, handler: { (UIAlertAction)in
                action.handler?()
            }))
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: footerTitle, style: .cancel) { action -> Void in
            self.dismissViewController()
        }
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: { })
    }
}
