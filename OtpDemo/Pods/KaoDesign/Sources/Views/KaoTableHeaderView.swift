//
//  KaoTableHeaderView.swift
//  Kaodim
//
//  Created by Ramkrishna on 17/07/2019.
//  Copyright © 2019 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation

open class KaoTableHeaderView: UIView {

    @IBOutlet private weak var titleLabel: KaoLabel!
    private var contentView: UIView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {

        let nib = UIView.nibFromDesignIos("KaoTableHeaderView")
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

        titleLabel.font = UIFont.kaoFont(style: .semibold, size: 12)
    }

    public func configure(_ title: String?) {
        titleLabel.text = title
    }
}
