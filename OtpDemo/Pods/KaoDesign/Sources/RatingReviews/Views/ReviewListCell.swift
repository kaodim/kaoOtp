//
//  ReviewListCell.swift
//  KaoDesign
//
//  Created by augustius cokroe on 15/04/2019.
//

import Foundation

public class ReviewListCell: UITableViewCell, NibLoadableView {

	@IBOutlet private weak var userIcon: UIImageView!
	@IBOutlet private weak var userName: KaoLabel!
	@IBOutlet private weak var serviceName: KaoLabel!
	@IBOutlet private weak var ratingView: KaoRatingView!
	@IBOutlet private weak var dateRange: KaoLabel!
	@IBOutlet private weak var commentView: UIView!
	@IBOutlet private weak var commentLabel: KaoLabel!

	@IBOutlet private weak var selectedTagsContainer: UIView!
	@IBOutlet private weak var complimentButton: UIButton!
	@IBOutlet private weak var collectionView: UICollectionView!
	@IBOutlet private weak var collectionViewHeight: NSLayoutConstraint!

	@IBOutlet private weak var replyButton: UIButton!

	@IBOutlet private weak var replyViewContainer: UIView!
	@IBOutlet private weak var replySeperatorView: UIView!
	@IBOutlet private weak var replyLabel: KaoLabel!
	@IBOutlet private weak var replyDescLabel: KaoLabel!

	@IBOutlet private weak var editButton: UIButton!

	private lazy var leftVerticalFlowLayout: UICollectionViewLayout = {
		let layout = LeftVerticalFlowLayout()
		layout.estimatedItemSize = CGSize(width: 271, height: 37)
		layout.sectionInset = UIEdgeInsets(top: 13, left: 0, bottom: 24, right: 0)
        layout.minimumInteritemSpacing = 8.0
        layout.minimumLineSpacing = 8.0
		layout.scrollDirection = .vertical
		return layout
	}()

	private let cellIdentifier = "ReviewListTagCell"
	private var currentReview: BasicReview?
	private var selectedTags: [SelectedReviewTag] = [] {
		didSet {
			self.collectionView.reloadData()
		}
	}
	private var uniqueIdentifier: Int!
	private var complimentText = ""
	var replyTapped: ((_ review: Review) -> Void)?
	var editTapped: ((_ review: Review) -> Void)?
	public var reloadRow: ((_ row: Int) -> Void)?

	override public func awakeFromNib() {
		super.awakeFromNib()

		userIcon.makeRoundCorner()
		userName.font = UIFont.kaoFont(style: .medium, size: 15)
		serviceName.font = UIFont.kaoFont(style: .regular, size: 14)
		dateRange.font = UIFont.kaoFont(style: .regular, size: 13)
		commentLabel.font = UIFont.kaoFont(style: .regular, size: 15)
		replyButton.titleLabel?.font = UIFont.kaoFont(style: .regular, size: 15)
		replySeperatorView.addCornerRadius(2)
		replyLabel.font = UIFont.kaoFont(style: .medium, size: 14)
		replyDescLabel.font = UIFont.kaoFont(style: .regular, size: 15)
		editButton.titleLabel?.font = UIFont.kaoFont(style: .regular, size: 15)
		selectedTagsContainer.isHidden = true

		collectionView.dataSource = self
		collectionView.collectionViewLayout = leftVerticalFlowLayout
		collectionView.register(UIView.nibFromDesignIos(cellIdentifier) , forCellWithReuseIdentifier: cellIdentifier)
	}

	public override func prepareForReuse() {
		super.prepareForReuse()
		selectedTags = []
		hideComplimentButton(true)
		selectedTagsContainer.isHidden = true
		collectionView.reloadData()
	}

	public func configure(_ review: Review, localization: RatingReviewLocalization, uniqueID: Int) {
		uniqueIdentifier = uniqueID
		currentReview = review
		selectedTags = currentReview?.reviewTags ?? []
		userIcon?.cache(withURL: review.avatarUrl ?? "", placeholder: UIImage.imageFromDesignIos("avatar"))
		userName.text = review.name
		serviceName.text = review.description
		ratingView.rating = Float(review.rating ?? 0)
		dateRange.text = review.createdAtStr

		complimentText = localization.translate(.compliment)
		configureComment(review.comment)
		configureReply(review, localization: localization)
		configureCompliment(review.reviewTags.count)
		self.contentView.setNeedsLayout()
	}

	private func configureComment(_ comment: String) {
		let hasComment = !comment.isEmpty
		commentView.isHidden = hasComment ? false : true
		commentLabel.text = hasComment ? comment : nil
	}

	public func configureCompliment(_ count: Int) {
		let noCompliment = count == 0

		if !noCompliment {
			complimentButton.setTitle("+\(count) \(complimentText)", for: .normal)
		}

		hideComplimentButton(noCompliment)
	}

	public func configureShowCompliment(_ show: Bool) {
		selectedTagsContainer.isHidden = !show
	}

	public func hideComplimentButton(_ show: Bool) {
		complimentButton.isHidden = show
	}

	@IBAction func showCompliment() {
		configureShowCompliment(true)
		hideComplimentButton(true)
		reloadRow?(uniqueIdentifier)
	}

	public func setupDescriptionReview() {
		serviceName.isHidden = true
		replyButton.isHidden = true
		replyViewContainer.isHidden = true
	}

	private func configureReply(_ review: Review, localization: RatingReviewLocalization) {
		replyButton.setTitle(localization.translate(.reply), for: .normal)
		replyButton.isHidden = !(review.canReply ?? false)

		if let reply = review.reply {
			replyButton.isHidden = true
			replyViewContainer.isHidden = false
			let text1 = review.businessName ?? ""
			let text2 = localization.translate(.replied)
			let joinedText = [text1, text2].joined(separator: " ")
			let attrStr = NSMutableAttributedString(string: joinedText)
            let attrDict = [NSAttributedString.Key.font: UIFont.kaoFont(style: .regular, size: 14)]
			attrStr.addAttributes(attrDict, range: NSRange(location: joinedText.count - text2.count, length: text2.count))
			replyLabel.attributedText = attrStr
			replyDescLabel.text = reply.comment
			editButton.setTitle(localization.translate(.edit), for: .normal)
			editButton.isHidden = !(reply.canEdit ?? false)
		} else {
			replyViewContainer.isHidden = true
		}
	}

	@IBAction private func replyTap() {
		guard let currentReview = currentReview as? Review else { return }
		replyTapped?(currentReview)
	}

	@IBAction private func editTap() {
		guard let currentReview = currentReview as? Review else { return }
		editTapped?(currentReview)
	}

	override public func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {

		collectionView.layoutIfNeeded()
		collectionViewHeight.constant = collectionView.contentSize.height
        return self.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
	}
}

extension ReviewListCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return selectedTags.count
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ReviewListTagCell else {
			fatalError("Cell not found.")
		}
		let reviewTag = selectedTags[indexPath.row]
		cell.configure(reviewTag.iconUrl ?? "", text: reviewTag.name)
		return cell
	}
}

