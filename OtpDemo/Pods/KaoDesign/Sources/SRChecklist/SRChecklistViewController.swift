//
//  SRChecklistViewController.swift
//  KaoDesign
//
//  Created by Augustius on 17/12/2019.
//

import Foundation

class SRChecklistViewController: KaoSlideUpViewController {

    private lazy var tableView: UITableView = {
        let view = UITableView.kaoDefault(style: .grouped, delegate: viewModel, dataSource: viewModel)
        view.registerFromDesignIos(SRChecklistItemCell.self)
        view.registerFromDesignIos(SRChecklistShowAllCell.self)
        view.setAndLayoutTableHeaderView(header: topView)
        view.setAndLayoutTableFooterView(footer: bottomView)
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
    }()

    private lazy var topView: SRChecklistTop = {
        let view = SRChecklistTop()
        view.configure(NSLocalizedString("checklist_title", comment: ""))
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

    private var viewModel: SRChecklistViewModel!
    private var helpCallback: (() -> Void)?

    init(checklists: [SRChecklist], localizedStrings: KaoCalendarLocalize, helpCallback: (() -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.helpCallback = helpCallback
        viewModel = SRChecklistViewModel(checklists, localizedStrings: localizedStrings)
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

extension SRChecklistViewController: SRChecklistVMEventDelegate {
    func itemsConfigured() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func reloadSection(_ section: Int) {
        UIView.performWithoutAnimation {
            tableView.reloadSections([section], with: .none)
        }
    }
}

// MARK: - Extension
public extension UIViewController {
    func presentSRChecklistVC(checklists: [SRChecklist], localizedStrings: KaoCalendarLocalize, helpCallback: (() -> Void)?) {
        let view = SRChecklistViewController(checklists: checklists, localizedStrings: localizedStrings, helpCallback: helpCallback)
        view.modalPresentationStyle = .overFullScreen
        present(view, animated: false, completion: nil)
    }
}

