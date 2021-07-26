//
//  SRChecklistFooter.swift
//  KaoDesign
//
//  Created by Augustius on 17/12/2019.
//

import Foundation

public class SRChecklistFooter: UIView {

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
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
        let nib = UIView.nibFromDesignIos("SRChecklistFooter")
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
    }
}

