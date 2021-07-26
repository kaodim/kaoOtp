//
//  RatingAvgHeaderView.swift
//  KaoDesign
//
//  Created by augustius cokroe on 15/04/2019.
//

import Foundation

public class RatingAvgHeaderView: UIView {
    @IBOutlet private weak var titleLabel: KaoLabel!
    @IBOutlet private weak var sortButtonView: UIView!
    @IBOutlet private weak var sortButtonLabel: KaoLabel!
    @IBOutlet private weak var fiveProgressView: UIProgressView!
    @IBOutlet private weak var fourProgressView: UIProgressView!
    @IBOutlet private weak var threeProgressView: UIProgressView!
    @IBOutlet private weak var twoProgressView: UIProgressView!
    @IBOutlet private weak var oneProgressView: UIProgressView!
    @IBOutlet private weak var avgRating: KaoLabel!
    @IBOutlet private weak var ratingView: KaoRatingView!
    @IBOutlet private weak var totalRating: KaoLabel!
    
    private var contentView: UIView!
    private var allProgressView: [UIProgressView] = []
    
    public var sortDidTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("RatingAvgHeaderView")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    private func configureViews() {
        contentView = loadFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)

        allProgressView = [oneProgressView, twoProgressView, threeProgressView, fourProgressView, fiveProgressView]
        allProgressView.enumerated().forEach({ (index, progressView) in
            progressView.addCornerRadius(2)
            progressView.progress = 0
            progressView.tag = index + 1
        })

        avgRating.font = UIFont.kaoFont(style: .medium, size: 36)
        totalRating.font = UIFont.kaoFont(style: .regular, size: 14)
        titleLabel.font = UIFont.kaoFont(style: .bold, size: 18)
        sortButtonLabel.font = UIFont.kaoFont(style: .regular, size: 14)
        
        sortButtonView.addCornerRadius(18)
        sortButtonView.addBorderLine(color: .kaoColor(.mercury))
        
        titleLabel.textColor = .kaoColor(.black)
        sortButtonLabel.textColor = .kaoColor(.black)
    }

    public func configure(_ rating: Rating, ratingText: String, titleText: String, hideSortButton: Bool = true) {
        ratingView.rating = Float(rating.ratingAverage)
        avgRating.text = String(format: "%.1f", rating.ratingAverage)
        totalRating.text = "\(rating.ratingCount) \(ratingText)"
        titleLabel.text = titleText
        
        sortButtonView.isHidden = hideSortButton
        allProgressView.forEach { (progessView) in
            let ratingCount = rating.ratingCountGrouped.first(where: { $0.ratingText == "\(progessView.tag)" })?.count ?? 0
            let progress: Float = Float(ratingCount) / Float(rating.ratingCount)
            progessView.progress = progress
        }
    }
    
    public func configureEmptyState(ratingText: String, titleText: String) {
        avgRating.isHidden = true
        ratingView.isHidden = true
        sortButtonView.isHidden = true
        
        titleLabel.text = titleText
        totalRating.text = ratingText
        
        allProgressView.forEach { (progessView) in
            progessView.progress = 0
        }
    }
    
    public func setSortButtonText(text: String) {
        sortButtonLabel.text = text
    }

    @IBAction func onTappedFilter(_ sender: Any) {
        sortDidTapped?()
    }
}
