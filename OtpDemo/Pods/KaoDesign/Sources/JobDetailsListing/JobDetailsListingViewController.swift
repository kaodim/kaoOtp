//
//  JobDetailsListingViewController.swift
//  Kaodim
//
//  Created by Ramkrishna on 10/07/2019.
//  Copyright © 2019 Kaodim Sdn Bhd. All rights reserved.
//

import UIKit

protocol JobDetailsListingControllerFactory {
    func makeJobDetailsListingController() -> JobDetailsListingViewController
    func makeJobDetailsListingViewModel() -> JobDetailsListingViewModel
}

class JobDetailsListingDependencyContainer: JobDetailsListingControllerFactory {

    let jobDetailsData: JobDetailsListingData

    init(_ jobDetailsData: JobDetailsListingData) {
        self.jobDetailsData = jobDetailsData
    }

    func makeJobDetailsListingController() -> JobDetailsListingViewController {
        JobDetailsListingViewController(factory: self)
    }

    func makeJobDetailsListingViewModel() -> JobDetailsListingViewModel {
        JobDetailsListingViewModel(jobDetailsData)
    }

}

class JobDetailsListingViewController: KaoTableViewBottomSheetViewController {

    // MARK: - Properties

    // MARK: - Dependency Injection
    // Here we use protocol composition to create a Factory type that includes
    // all the factory protocols that this view controller needs.
    typealias Factory = JobDetailsListingControllerFactory
    private let factory: Factory
    private lazy var viewModel = factory.makeJobDetailsListingViewModel()

    private var bottomViewConstraint: NSLayoutConstraint!
    var headerHeightConstraint: NSLayoutConstraint!

    public lazy var tableView: UITableView = {
        let view = UITableView.kaoDefault(style: .plain, delegate: nil, dataSource: nil)
        view.registerFromDesignIos(KaoIconAndTitleCell.self)
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.removeFooterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var tableHeader: KaoHeaderView = {
        let header = KaoHeaderView()
        let edge = UIEdgeInsets.init(top: 0, left: 0, bottom: 13, right: 0)
        header.configureEdge(edge)
        header.configure(viewModel.jobDetailsData.cellData.cellTitle)
        header.configureSeperatorColor(.clear)
        return header
    }()

    private var contentView = UIView()

    private lazy var headerView: KaoSlideUpHeaderView = {
        let view = KaoSlideUpHeaderView()
        view.configureData(viewModel.jobDetailsData.headerData)
        return view
    }()

    init(factory: Factory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tableViewHeight: CGFloat {
        tableView.layoutIfNeeded()
        return tableView.frame.height
    }

    override public func viewWillAppear(_ animated: Bool) {
        let height = tableViewHeight
        super.presentViewHeight = 10
        super.viewWillAppear(animated)
    }

    override public func viewDidLoad() {
        setUpContentView()
        super.presentView = self.contentView
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureLayout()
        configureViewModel()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    private func configureLayout() {
        headerView.delegate = self
        self.view.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }

    private func configureViewModel() {
        self.items = []
        let cellItems = JobDetailsListingItem(viewModel.jobDetailsData.cellData, false)
        self.items.append(cellItems)
        self.tableView.reloadData {
            self.tableView.setAndLayoutTableHeaderView(header: self.tableHeader)
        }
    }

    override func viewDidLayoutSubviews() {
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
        tableView.reloadData()
        self.presentViewHeight = tableView.frame.height + 50
        self.startAnimate()
    }

    func setUpContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        setUpHeader()
        setUpTableView()
    }

    func setUpHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerView)
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: 50)
        headerHeightConstraint.isActive = true
        let constraints: [NSLayoutConstraint] = [
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)
        let constraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}

// MARK: - KaoSlideUpHeaderView Delegate

extension JobDetailsListingViewController: KaoSlideUpHeaderViewProtocol {
    func didTapOnRightBtn() {
        self.dismiss(animated: false, completion: nil)
    }

    func didTapOnLeftBtn() { }
}

extension UIViewController {
    public func presentJobDetailsListing(_ jobDetailsData: JobDetailsListingData) {
        let container = JobDetailsListingDependencyContainer(jobDetailsData)
        let view = container.makeJobDetailsListingController()
        view.modalPresentationStyle = .overFullScreen
        present(container.makeJobDetailsListingController(), animated: false, completion: nil)
    }
}
