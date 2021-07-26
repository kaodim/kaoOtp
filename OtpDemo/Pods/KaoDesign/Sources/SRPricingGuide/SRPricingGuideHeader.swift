//
//  SRPricingGuideHeader.swift
//  KaoDesign
//
//  Created by Augustius on 20/12/2019.
//

import Foundation

class SRPricingGuideHeader: UIView {

    @IBOutlet private weak var titleLabel: KaoLabel!
    @IBOutlet private weak var closeButton: UIButton!
    private var contentView: UIView!
    var closeTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("SRPricingGuideHeader")
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

        titleLabel.font = UIFont.kaoFont(style: .semibold, size: 16)
        titleLabel.textColor = .kaoColor(.black)
        closeButton.titleLabel?.font = .kaoFont(style: .medium, size: 15)
        closeButton.setTitleColor(.kaoColor(.vividBlue), for: .normal)
    }

    public func configure(_ title: String, buttonTitle: String) {
        titleLabel.text = title
        closeButton.setTitle(buttonTitle, for: .normal)
    }

    @IBAction private func closeTap() {
        closeTapped?()
    }
}
