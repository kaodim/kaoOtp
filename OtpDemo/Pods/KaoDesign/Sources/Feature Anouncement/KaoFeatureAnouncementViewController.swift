//
//  KaoFeatureAnouncementViewController.swift
//  Kaodim
//
//  Created by Ramkrishna on 10/07/2019.
//  Copyright © 2019 Kaodim Sdn Bhd. All rights reserved.
//

import UIKit

public protocol KaoFeatureAnnouncementControllerFactory {
    func makeKaoFeatureAnnouncementController() -> KaoFeatureAnnouncementViewController
    func makeKaoFeatureAnnouncementViewModel() -> KaoFeatureAnnouncementViewModel
}

public protocol KaoFeatureAnnouncementDelegate: class {
    func footerTapped(_ url: String)
    func cellBtnTapped()
    func bottomBtnTapped()
    func doneBtnTapped()
}

open class KaoFeatureAnnouncementDependencyContainer: KaoFeatureAnnouncementControllerFactory {

    let featureData: KaoFeatureAnnouncementData

    public init(_ featureData: KaoFeatureAnnouncementData) {
        self.featureData = featureData
    }

    open func makeKaoFeatureAnnouncementController() -> KaoFeatureAnnouncementViewController {
        KaoFeatureAnnouncementViewController(factory: self)
    }

    open func makeKaoFeatureAnnouncementViewModel() -> KaoFeatureAnnouncementViewModel {
        KaoFeatureAnnouncementViewModel(featureData)
    }
}

open class KaoFeatureAnnouncementViewController: KaoBottomSheetController {

    public typealias Factory = KaoFeatureAnnouncementControllerFactory
    public let factory: Factory
    private lazy var viewModel = factory.makeKaoFeatureAnnouncementViewModel()

    private var bottomViewConstraint: NSLayoutConstraint!
    var headerHeightConstraint: NSLayoutConstraint!
    weak public var delegate: KaoFeatureAnnouncementDelegate?

    public lazy var tableView: UITableView = {
        let view = UITableView.kaoDefault(style: .grouped, delegate: viewModel, dataSource: viewModel)
        view.registerFromDesignIos(KaoFeatureAnnouncementCell.self)
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.removeFooterView()
        view.estimatedRowHeight = 300
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var contentView = UIView()

    private lazy var bottomView: KaoBottomButtonWithText = {
        let view = KaoBottomButtonWithText()
        view.backgroundColor = .white
        view.buttonTap = { [weak self] in
            self?.dismissAnimation()
            self?.delegate?.bottomBtnTapped()
        }

        view.linkTapped = { url in
            self.delegate?.footerTapped(url.absoluteString)
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var headerView: KaoSlideUpHeaderView = {
        let view = KaoSlideUpHeaderView()
        view.delegate = self
        return view
    }()

    private lazy var footerView: FooterActionView = {
        let footer = FooterActionView()

        footer.heightAnchor.constraint(equalToConstant: 80).isActive = true

        return footer
    }()

    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 257).isActive = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    public init(factory: Factory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewWillAppear(_ animated: Bool) {
        let height = phoneHasNotch ? UIScreen.main.bounds.height * 0.90 : UIScreen.main.bounds.height * 0.95
        super.maxPresentHeight = height
        super.presentViewHeight = height
        super.viewWillAppear(animated)
    }

    override open func viewDidLoad() {
        super.presentView = self.contentView
        super.viewDidLoad()
        viewModel.eventDelegate = self
        configureLayout()
        configureViewModel()
        setupTableViewContentInset(UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0))
        // Do any additional setup after loading the view.
    }

    private func configureLayout() {
        setUpContentView()

        view.addSubview(bottomView)
        view.backgroundColor = .clear

        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: 0),
            bottomView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func configureViewModel() {
        viewModel.reloadView()

        viewModel.buttonTapped = { [weak self] in
            self?.cellButtonTapped()
        }

        self.tableView.reloadData {
            self.tableView.setAndLayoutTableHeaderView(header: self.headerImageView)
        }
        self.headerImageView.image = viewModel.featureData.image
        self.bottomView.configureButton(viewModel.featureData.buttonTitle)
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

    open func setupNavHeaderUI(_ headerData: KaoSlideUpHeaderData) {
        headerView.configureData(headerData)
    }

    open func setupTableFooterView(_ footerText: NSAttributedString) {
        self.bottomView.configureDescription(footerText, linkAttributes: [:])
    }

    open func setupTableViewContentInset(_ contentInset: UIEdgeInsets) {
        tableView.contentInset = contentInset
    }

    func cellButtonTapped() {
        delegate?.cellBtnTapped()
    }

}

extension KaoFeatureAnnouncementViewController: BaseVMEventDelegate, KaoSlideUpHeaderViewProtocol {
    public func didTapOnLeftBtn() {

    }

    public func didTapOnRightBtn() {
        delegate?.doneBtnTapped()
        self.dismissAnimation()
    }

    public func itemsConfigured() {
        self.tableView.reloadData()
    }
}
