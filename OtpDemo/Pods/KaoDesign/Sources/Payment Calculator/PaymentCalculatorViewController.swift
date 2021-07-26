//
//  PaymentCalculatorViewController.swift
//  KaoDesign
//
//  Created by Ramkrishna on 18/05/2020.
//

import UIKit

public protocol PaymentCalculatorControllerFactory {
}

public protocol PaymentCalculatorDelegates: BaseViewModelEvent {
    func viewDetailsTapped()
    func editAmountTapped()
    func linkTapped(_ url: URL, _ source: UIView)
    func leftIconTapped(_ url: URL, _ source: UIView)
}

open class PaymentCalculatorDependencyContainer: PaymentCalculatorControllerFactory {
    public init() { }
}

open class PaymentCalculatorViewController: KaoTableViewController {

    // MARK: - Dependency Injection
    // Here we use protocol composition to create a Factory type that includes
    // all the factory protocols that this view controller needs.
    public typealias Factory = PaymentCalculatorControllerFactory

    private let factory: Factory
    public weak var delegate: PaymentCalculatorDelegates?
    public var viewModel: PaymentCalculatorViewModel?

    public init(factory: Factory) {
        self.factory = factory
        let podBundle = Bundle(for: PaymentCalculatorViewController.self)
        let bundleURL = podBundle.url(forResource: "KaoCustomPod", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)
        super.init(nibName: "PaymentCalculatorViewController", bundle: bundle)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("Deallocated...")
    }

    @IBOutlet public weak var tableView: UITableView!
    @IBOutlet weak var headerBkgView: UIView!
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet private weak var bottomButtonView: KaoBottomButtonView!

    open override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel?.eventDelegate = self
        tableView.separatorStyle = .none
        setupUI()
        // Do any additional setup after loading the view.
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTransparentNavigationBar(true)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureTransparentNavigationBar(false)
    }

    open func setViewModel(_ viewModel: PaymentCalculatorViewModel) {
        self.viewModel = viewModel
        configureUI()
    }

    open func setAmount(_ amount: String) { }

    open func setButtonTitle(_ title: String) {
        self.bottomButtonView.title = title
    }

    open func configureTransparentNavigationBar(_ isTransparent: Bool) { }

    open func getTableView() -> UITableView {
        self.tableView
    }
    
    private func setupUI() {
        tableView.backgroundColor = .kaoColor(.veryLightPink)
        tableView.registerFromDesignIos(PaymentCalculatorCell.self)
        tableView.separatorStyle = .none
        setupRightBarItem()
        bottomButtonView.isHidden = true
    }

    public func setupRightBarItem(_ icon: UIImage? = UIImage.imageFromDesignIos("ic_close_light")) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(dismissViewController))
    }

    public func configureUI() {
        configureHeaderBkgView(self.headerBkgView)
        configureTableView()
        configureHeaderView(self.headerContentView)
        configureTableHeaderView()
        configureTableFooterView()
        configureBottomButtonView(self.bottomButtonView)
    }

    open func configureTableView() {
        self.items = []
        guard let viewModel = viewModel,
            let items = viewModel.paymentCalculatorData?.items else { return }
        let cellItem = PaymentCalculatorCellItem(items)

        cellItem.cellButtonTapped = { [weak self] in
            self?.delegate?.viewDetailsTapped()
        }
        cellItem.linkTapped = { [weak self] (url, source) in
            self?.delegate?.linkTapped(url, source)
        }
        
        cellItem.leftIconTapped = { [weak self] (url, source) in
            self?.delegate?.leftIconTapped(url, source)
        }

        self.items.append(cellItem)
        self.tableView.reloadData()
    }

    open func configureHeaderBkgView(_ headerBkgView: UIView) { }
    open func configureHeaderView(_ headerContentView: UIView) { }
    open func configureTableFooterView() { }
    open func configureTableHeaderView() { }
    open func configureBottomButtonView(_ bottomButtonView: KaoBottomButtonView) { }

    open func setTableFooterView(_ footerView: UIView) {
        tableView.setAndLayoutTableFooterView(footer: footerView)
    }

    open func setTableHeaderView(_ headerView: UIView) {
        tableView.setAndLayoutTableHeaderView(header: headerView)
    }

    open func enableBottomButton() {
        if let amount = viewModel?.paymentCalculatorData?.header?.amount, !amount.isEmpty {
            bottomButtonView.enableButton = true
        } else {
            bottomButtonView.enableButton = false
        }
    }

    open func animateView() { }
}

extension PaymentCalculatorViewController: BaseViewModelEvent {
    open func dataConfigured() { }
    open func dataSourceFail(with errMsg: String) { }
}
