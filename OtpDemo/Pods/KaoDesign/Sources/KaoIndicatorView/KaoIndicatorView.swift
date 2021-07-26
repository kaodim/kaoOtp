//
//  KaoIndicatorView.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 10/22/19.
//

import UIKit

public enum IndicatorType: String {
    case orange, red, blue, green, yellow, grey
}

public class KaoIndicatorView: UIView {

    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var sideDivider: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var iconImage1: UIImageView!
    @IBOutlet private weak var iconImage2: UIImageView!
    @IBOutlet private weak var iconImageWidth: NSLayoutConstraint!

    @IBOutlet weak var iconContentView: UIStackView!
    @IBOutlet private weak var backgroundViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var backgroundViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundViewTopConstraint: NSLayoutConstraint!

    @IBOutlet private weak var descriptionLabelTop: NSLayoutConstraint!
    @IBOutlet private weak var descriptionLabelBottom: NSLayoutConstraint!
    @IBOutlet private weak var descriptionLabelTrailing: NSLayoutConstraint!
    @IBOutlet private weak var descriptionLabelLeading: NSLayoutConstraint!

    @IBOutlet private weak var linkContentView: UIView!
    @IBOutlet private weak var linkLabel: UILabel!
    @IBOutlet private weak var linkIcon: UIImageView!


    private var contentView: UIView!

    public var noticeTap: (() -> Void)?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        contentView = loadFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
        showLeftIcon(false)
        linkContentView.isHidden = true

        linkLabel.font = .kaoFont(style: .medium, size: 16)
        linkLabel.textColor = .kaoColor(.vividBlue)
        linkIcon.tintColor = .kaoColor(.vividBlue)
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoIndicatorView")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    public func configureType(_ type: IndicatorType) {
        switch type {
        case .orange, .yellow:
            configureUI(UIColor.kaoColor(.kaodimOrange), UIColor.kaoColor(.kaodimOrange10), UIColor.kaoColor(.textOrange))
        case .red:
            configureUI(UIColor.kaoColor(.crimson), UIColor.kaoColor(.kaodimRed10), UIColor.kaoColor(.textRed))
        case .blue:
            configureUI(UIColor.kaoColor(.vividBlue), UIColor.kaoColor(.hawkesBlue), UIColor.kaoColor(.textBlue))
        case .green:
            configureUI(.kaoColor(.malachite), .kaoColor(.kaodimGreen10), .kaoColor(.textGreen))
        case .grey:
            configureUI(.kaoColor(.dustyGray2), .kaoColor(.dustyGray2), .kaoColor(.veryLightPink))
        }
    }

    private func configureUI(_ sideColor: UIColor, _ bkgColor: UIColor, _ descLabelColor: UIColor) {
        sideDivider.backgroundColor = sideColor
        backgroundView.backgroundColor = bkgColor
        descriptionLabel.textColor = descLabelColor
    }

    public func configureEdges(_ edges: UIEdgeInsets) {
        backgroundViewTopConstraint.constant = edges.top
        backgroundViewLeadingConstraint.constant = edges.left
        backgroundViewTrailingConstraint.constant = edges.right
        backgroundViewBottomConstraint.constant = edges.bottom
    }

    public func configureIconFromLibrary(_ image: String) {
        showLeftIcon(true)
        iconImage1.image = UIImage.imageFromDesignIos(image)
    }

    public func configureIconUrl(_ url: String) {
        showLeftIcon(true)
        iconImage1.cache(withURL: url)
    }

    public func configureIconGif(_ image1: String, _ image2: String?) {
        showLeftIcon(true)
        let podBundle = Bundle(for: KaoIndicatorView.self)
        let bundleURL = podBundle.url(forResource: "KaoCustomPod", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        if let asset = NSDataAsset(name: image1, bundle: bundle), let image = UIImage.gif(data: asset.data) {
            iconImage1.image = image
            iconImage1.isHidden = false
        } else {
            iconImage1.isHidden = true
        }

        if let image2 = image2, let asset = NSDataAsset(name: image2, bundle: bundle), let image = UIImage.gif(data: asset.data) {
            iconImage2.image = image
            iconImage2.isHidden = false
        } else {
            iconImage2.isHidden = true
        }
    }

    public func showLeftIcon(_ shouldShow: Bool) {
        iconContentView.isHidden = !shouldShow
    }

    public func configureViewHeight(_ height: CGFloat) {
        //backgroundViewHeight.constant = height
    }

    public func configureDescription(_ description: String) {
        descriptionLabel.text = description
        descriptionLabel.sizeToFit()
        self.setNeedsDisplay()
    }

    public func configureDescriptionWithLineSpacing(_ description: String, _ lineHeight: CGFloat) {
        let attributeString = NSMutableAttributedString(string: description)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineHeight
        attributeString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, description.count))
        descriptionLabel.attributedText = attributeString
        descriptionLabel.sizeToFit()
        self.setNeedsDisplay()
    }

    public func configureLinkAttrString(_ description: String, linkText: String?, _ linkIcon: UIImage? = UIImage.imageFromDesignIos("icon_chevron_right")) {
        linkContentView.isHidden = false
        descriptionLabel.text = description
        linkLabel.text = linkText
        self.linkIcon.image = linkIcon
        descriptionLabel.sizeToFit()
        self.setNeedsDisplay()
    }

    @IBAction func noticeDidTap() {
        noticeTap?()
    }
}

