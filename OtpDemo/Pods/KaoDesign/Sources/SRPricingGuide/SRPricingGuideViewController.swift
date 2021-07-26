//
//  SRPricingGuideViewController.swift
//  KaoDesign
//
//  Created by Augustius on 19/12/2019.
//

import Foundation

class SRPricingGuideViewController: KaoSlideUpViewController {

    var headerTitle: String = ""
    var closeBtnTitle: String = ""

    private lazy var tableView: UITableView = {
        let view = UITableView.kaoDefault(style: .grouped, delegate: viewModel, dataSource: viewModel)
        view.registerFromDesignIos(SRPricingGuideUnitCell.self)
        view.registerFromDesignIos(SRPricingGuideUnitItemCell.self)
        view.setAndLayoutTableHeaderView(header: topView)
        view.setAndLayoutTableFooterView(footer: bottomView)
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
    }()

    private lazy var topView: SRPricingGuideHeader = {
        let view = SRPricingGuideHeader()
        view.configure(headerTitle, buttonTitle: closeBtnTitle)
        view.closeTapped = { [weak self] in
            self?.dismissAnimation()
        }
        return view
    }()

    private lazy var bottomView: SRChecklistBottom = {
        let view = SRChecklistBottom()
        view.buttonTapped = { [weak self] in
            self?.dismissAnimation({ [weak self] in
                self?.helpCallback?()
            })
        }
        return view
    }()

    private var viewModel: SRPricingGuideViewModel!
    private var helpCallback: (() -> Void)?

    init(pricingGuides: [SRPricingGuide], helpCallback: (() -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.helpCallback = helpCallback
        viewModel = SRPricingGuideViewModel(pricingGuides)
        viewModel.eventDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.presentView = tableView
        super.presentViewHeight = super.maxPresentHeight
        super.needGesture = false
        super.viewDidLoad()
    }
}

extension SRPricingGuideViewController: BaseVMEventDelegate {
    func itemsConfigured() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - Extension
public extension UIViewController {
    func presentSRPricingGuideVC(title: String, closeBtnTitle: String, pricingGuides: [SRPricingGuide], helpCallback: (() -> Void)?) {
        let view = SRPricingGuideViewController(pricingGuides: pricingGuides, helpCallback: helpCallback)
        view.headerTitle = title
        view.closeBtnTitle = closeBtnTitle
        view.modalPresentationStyle = .overFullScreen
        present(view, animated: false, completion: nil)
    }
}
