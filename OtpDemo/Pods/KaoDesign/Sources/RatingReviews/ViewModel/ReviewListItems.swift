//
//  ReviewListItems.swift
//  KaoDesign
//
//  Created by augustius cokroe on 16/04/2019.
//

import Foundation

public class ReviewListItems: TableViewVMProtocol {

    public var rowCount: Int {
        return reviews.count
    }

    private var showedReview: [Int] = []
    private var reviews: [Review]
    private var totalReview: Int
    private var localization: RatingReviewLocalization
    public var selectedRating: RatingSorting?

    var replyTapped: ReviewListCellCallback
    var editTapped: ReviewListCellCallback
    public var reloadRow: (() -> Void)?

    public init(_ reviews: [Review], totalReview: Int, localization: RatingReviewLocalization, replyTapped: ReviewListCellCallback, editTapped: ReviewListCellCallback) {
        self.reviews = reviews
        self.totalReview = totalReview
        self.localization = localization
        self.replyTapped = replyTapped
        self.editTapped = editTapped
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let review = self.reviews[indexPath.row]
        let cell: ReviewListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(review, localization: localization, uniqueID: review.id ?? indexPath.row)
        cell.replyTapped = { (replyText) in
            self.replyTapped?(replyText, indexPath)
        }
        cell.editTapped = { (replyText) in
            self.editTapped?(replyText, indexPath)
        }
        cell.reloadRow = { id in
            self.showedReview.append(id)
            self.reloadRow?()
        }

        let reviewShown = showedReview.contains(review.id ?? 0)
        cell.configureShowCompliment(reviewShown)
        cell.hideComplimentButton(reviewShown)

        if review.rating ?? 0 < 5 || review.reviewTags.count == 0 {
            cell.hideComplimentButton(true)
        }

        return cell
    }
}
