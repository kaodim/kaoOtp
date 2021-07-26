//
//  KaoBadgeView.swift
//  Kaodim
//
//  Created by Ramkrishna on 24/07/2019.
//  Copyright © 2019 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation

open class KaoBadgeView: UIView {

    @IBOutlet private weak var countView: UIView!
    @IBOutlet private weak var countLabel: UILabel!

    private var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoBadgeView")
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
        countLabel.font = UIFont.kaoFont(style: .medium, size: 12)
        countView.addCornerRadius(10)
    }

    public func configureTitle(_ count: Int) {
        countLabel.text = (count > 99) ? "99+" : "\(count)"
    }
}
