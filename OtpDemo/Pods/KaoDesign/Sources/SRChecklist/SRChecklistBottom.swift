//
//  SRChecklistBottom.swift
//  KaoDesign
//
//  Created by Augustius on 17/12/2019.
//

import Foundation

class SRChecklistBottom: UIView {

    @IBOutlet private weak var linkButton: UIButton!
    private var contentView: UIView!

    var buttonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("SRChecklistBottom")
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

        linkButton.titleLabel?.textColor = .kaoColor(.vividBlue)
        linkButton.titleLabel?.font = .kaoFont(style: .medium, size: 15)
        linkButton.setTitle(NSLocalizedString("need_help_talk_us", comment: ""), for: .normal)
    }

    @IBAction private func buttonTap() {
        buttonTapped?()
    }
}
