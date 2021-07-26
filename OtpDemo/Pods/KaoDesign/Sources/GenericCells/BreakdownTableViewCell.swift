//
//  BreakdownTableViewCell.swift
//  KaoDesign
//
//  Created by Augustius on 27/05/2019.
//

import Foundation
import UIKit

public struct ItemInfo {
    public let description: String
    public let deeplinkUrl: String
    public let weblinkUrl: String

    public init(description: String, deeplinkUrl: String, weblinkUrl: String) {
        self.description = description
        self.deeplinkUrl = deeplinkUrl
        self.weblinkUrl = weblinkUrl
    }
}

public struct BreakdownTableViewCellData {
    public let rightFont: UIFont
    public let leftFont: UIFont
    public let rightText: NSAttributedString?
    public let leftText: NSAttributedString?
    public let leftSubtitle: String
    public let rightColor: UIColor
    public let leftColor: UIColor
    public let isSurchargeable: Bool
    public let isRebatable: Bool
    public let itemInfo: ItemInfo?

    public init(_ rightFont: UIFont = UIFont.kaoFont(style: .regular, size: 15),
        leftFont: UIFont = UIFont.kaoFont(style: .regular, size: 15),
        rightText: NSAttributedString? = nil,
        leftText: NSAttributedString? = nil, leftSubtitle: String = "",
        rightColor: UIColor = UIColor.kaoColor(.black),
        leftColor: UIColor = UIColor.kaoColor(.black), isSurchargeable: Bool = false, isRebatable: Bool = false, itemInfo: ItemInfo? = nil) {
        self.rightFont = rightFont
        self.leftFont = leftFont
        self.rightText = rightText
        self.leftText = leftText
        self.leftSubtitle = leftSubtitle
        self.rightColor = rightColor
        self.leftColor = leftColor
        self.isSurchargeable = isSurchargeable
        self.isRebatable = isRebatable
        self.itemInfo = itemInfo
    }
}

public class BreakdownTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet private weak var cardViewTrailing: NSLayoutConstraint!
    @IBOutlet private weak var cardViewLeading: NSLayoutConstraint!
    @IBOutlet private weak var cardViewTop: NSLayoutConstraint!
    @IBOutlet private weak var cardViewBottom: NSLayoutConstraint!
    @IBOutlet private weak var seperatorBottom: NSLayoutConstraint!
    @IBOutlet private weak var seperatorView: UIView!
    @IBOutlet private weak var leftLabel: KaoLabel!
    @IBOutlet private weak var leftIcon: UIButton!
    @IBOutlet private weak var rightLabel: KaoLabel!
    @IBOutlet private weak var rightIcon: UIImageView!
    @IBOutlet private weak var subtitleView: UIView!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!

    public var leftTap: ((_ item: ItemInfo) -> Void)?
    public var linkTapped: ((_ url: URL) -> Void)?

    private var infoItem: ItemInfo!

    override public func awakeFromNib() {
        super.awakeFromNib()

        let defaultUI = BreakdownTableViewCellData.init(rightText: "".attributeString(), leftText: "".attributeString(), leftSubtitle: "")
        configureUI(defaultUI)
        hideLeftIcon(true)
        hideRightIcon(false, false)
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        hideSeperatorLine(lineBottomSpace: 0)
        configureEdge(UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 16))
        hideLeftIcon(true)
        hideRightIcon(false, false)
    }

    public func configureUI(_ uiData: BreakdownTableViewCellData) {
        infoItem = uiData.itemInfo
        leftLabel.textColor = uiData.leftColor
        rightLabel.textColor = uiData.rightColor
        leftLabel.font = uiData.leftFont
        rightLabel.font = uiData.rightFont
        rightLabel.attributedText = uiData.rightText
        configureSurchargable(uiData.isSurchargeable, uiData.isRebatable, uiData.itemInfo)
        configureSubtitle(uiData.leftSubtitle)
        configureLinkWithAttributes(uiData)
    }

    public func configureLinkWithAttributes(_ uiData: BreakdownTableViewCellData) {
        textView.attributedText = uiData.leftText
        textView.linkTextAttributes = [
            NSAttributedString.Key.font: UIFont.kaoFont(style: .regular, size: 14),
            NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.vividBlue)]
        textView.delegate = self
        textView.font = uiData.leftFont
        textView.textColor = uiData.leftColor
        leftLabel.isHidden = true
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
    }

    public func configureSubtitle(_ text: String) {
        if !text.isEmpty {
            subtitleLabel.text = text
            subtitleView.isHidden = false
        } else {
            subtitleView.isHidden = true
        }
    }

    public func configureSurchargable(_ isSurchargeable: Bool, _ isRebatable: Bool, _ itemInfo : ItemInfo?) {
        if let iteminfo = itemInfo {
            hideLeftIcon(!(isSurchargeable || isRebatable))
        } else {
            hideLeftIcon(true)
        }
        
        hideRightIcon(isSurchargeable, isRebatable)
    }

    public func configureEdge(_ edge: UIEdgeInsets) {
        cardViewTop.constant = edge.top
        cardViewBottom.constant = edge.bottom
        cardViewLeading.constant = edge.left
        cardViewTrailing.constant = edge.right
    }

    public func hideSeperatorLine(_ hide: Bool = true, lineBottomSpace: CGFloat = 12) {
        seperatorView.isHidden = hide
        seperatorBottom.constant = lineBottomSpace
    }

    public func hideLeftIcon(_ isHidden: Bool) {
        leftIcon.isHidden = isHidden
    }

    public func hideRightIcon(_ isSurchargeable: Bool, _ isRebatable: Bool) {

        rightIcon.isHidden = !(isSurchargeable || isRebatable)
        if !rightIcon.isHidden {
            let isPostiveSurcharge = isSurchargeable ? true : false
            configureGif(isPostiveSurcharge)
        }
    }

    public func getLeftPosition() -> UIButton {
        return leftIcon
    }

    public func getTextView() -> UITextView {
        textView
    }

    private func configureGif(_ isPostiveSurcharge: Bool) {
        let podBundle = Bundle(for: BreakdownTableViewCell.self)
        let bundleURL = podBundle.url(forResource: "KaoCustomPod", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        let icon = isPostiveSurcharge ? "surcharge_arrow" : "rebate_arrow_gif"
        if let asset = NSDataAsset(name: icon, bundle: bundle), let image = UIImage.gif(data: asset.data) {
            rightIcon.image = image
        }
    }

    @IBAction func leftDidTapped(_ sender: UIButton) {
        leftTap?(infoItem)
    }
}

extension BreakdownTableViewCell: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        self.linkTapped?(URL)
        return false
    }
}
