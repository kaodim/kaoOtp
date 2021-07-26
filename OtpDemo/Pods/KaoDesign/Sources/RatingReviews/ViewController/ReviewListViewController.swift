//
//  ReviewListViewController.swift
//  KaoDesign
//
//  Created by augustius cokroe on 16/04/2019.
//

import Foundation

open class ReviewListViewController: KaoBaseViewController {

    public lazy var headerView: RatingAvgHeaderView = {
        let view = RatingAvgHeaderView()
        return view
    }()

    public lazy var tableView: UITableView = {
        let view = UITableView.kaoDefault(style: .grouped, delegate: reviewListViewModel, dataSource: reviewListViewModel, bottomLoading: reviewListViewModel.paginationLoader)
        view.registerFromDesignIos(ReviewListCell.self)
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
    }()

    public var reviewListViewModel: ReviewListViewModel!
    public var localization: RatingReviewLocalization = RatingReviewLocalization()
    private var lastScrollIndex: IndexPath?

    open override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureLayout()
    }

    open func configureViewModel() {
        // override then initialize bfr call super.configureViewModel
        reviewListViewModel.reloadRow = { [weak self] in self?.reloadRow() }
        reviewListViewModel.localization = localization
        reviewListViewModel.replyTapped = { [weak self] (review, index) in self?.replyTapped(review, index) }
        reviewListViewModel.editTapped = { [weak self] (review, index) in self?.editTapped(review, index) }
        reviewListViewModel.configureHeaderLayout = { [weak self] rating in self?.configureHeaderLayout(rating) }
        reviewListViewModel.dataConfigured = { [weak self] in self?.reloadTable() }
        reviewListViewModel.load(page: 1)
    }

    private func configureLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(headerView)
        NSLayoutConstraint.activate([
        headerView.topAnchor.constraint(equalTo: safeTopAnchor),
        headerView.leadingAnchor.constraint(equalTo: safeLeadingAnchor),
        headerView.trailingAnchor.constraint(equalTo: safeTrailingAnchor),
        headerView.heightAnchor.constraint(equalToConstant: 170)
        ])
        
        
        view.addSubview(tableView)
        view.sendSubviewToBack(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeBottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeLeadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeTrailingAnchor)
            ])
    }

    private func reloadRow() {
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    private func scrollTo(_ indexPath: IndexPath) {
        lastScrollIndex = indexPath
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 500, right: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

    private func editViewDidDismiss() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func scrollToLastIndexIfExist() {
        if let lastIndex = lastScrollIndex {
            tableView.scrollToRow(at: lastIndex, at: .middle, animated: true)
        }
        lastScrollIndex = nil
    }

    // MARK: - Callback
    open func configureHeaderLayout(_ rating: Rating) {
        headerView.configure(rating, ratingText: localization.translate(.ratings), titleText: "", hideSortButton: true)
    }

    open func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData() {
                self.scrollToLastIndexIfExist()
            }
        }
    }

    open func replyTapped(_ review: Review, _ indexPath: IndexPath) {
        scrollTo(indexPath)
        presentReviewListReplyVC(review, localization: localization, sendTapped: { (replyText) in
            self.reviewListViewModel.sendReply(replyText, review: review, successCompletion: {
                self.dismiss(animated: false, completion: nil)
            })
        }, viewDidDismiss: editViewDidDismiss)
    }

    open func editTapped(_ review: Review, _ indexPath: IndexPath) {
        scrollTo(indexPath)
        presentReviewListEditVC(review, localization: localization, sendTapped: { (replyText) in
            self.reviewListViewModel.updateReply(replyText, review: review, successCompletion: {
                self.dismiss(animated: false, completion: nil)
            })
        }, viewDidDismiss: editViewDidDismiss)
    }
}
