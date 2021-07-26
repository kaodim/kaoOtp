//
//  SRChecklistHeader.swift
//  KaoDesign
//
//  Created by Augustius on 17/12/2019.
//

import Foundation

public class SRChecklistHeader: UIView {

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var titleLabel: KaoLabel!
    private var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("SRChecklistHeader")
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

        cardView.addCornerRadius(4)
        cardView.addBorderLine(color: .kaoColor(.veryLightPink))
        titleLabel.font = UIFont.kaoFont(style: .semibold, size: 16)
        titleLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 64 //16*4
    }

    public func configure(_ title: String) {
        titleLabel.text = title
    }
}
