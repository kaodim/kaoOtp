//
//  SRChecklistTop.swift
//  KaoDesign
//
//  Created by Augustius on 17/12/2019.
//

import Foundation

class SRChecklistTop: UIView {

    @IBOutlet private weak var headerView: SRPricingGuideHeader!
    @IBOutlet private weak var titleLabel: KaoLabel!
    private var contentView: UIView!
    var closeTapped: (() -> Void)? {
        didSet {
            headerView.closeTapped = closeTapped
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("SRChecklistTop")
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

        headerView.configure(NSLocalizedString("whats_included_text", comment: ""), buttonTitle: NSLocalizedString("close_btn_title", comment: ""))
        titleLabel.font = .kaoFont(style: .regular, size: 15)
        titleLabel.textColor = .kaoColor(.black)
        titleLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 32
    }

    public func configure(_ title: String) {
        titleLabel.text = title
    }
}
