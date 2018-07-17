//
//  OtpHeaderView.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

class OtpHeaderView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    private var contentView: UIView!
    var titleLabelAttr: CustomLabelAttributes! {
        didSet {
            titleLabel.font = titleLabelAttr.font
            titleLabel.textColor = titleLabelAttr.color
        }
    }
    var messageLabelAttr: CustomLabelAttributes! {
        didSet {
            messageLabel.font = messageLabelAttr.font
            messageLabel.textColor = messageLabelAttr.color
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
        let nib = UINib(nibName: "OtpHeaderView", bundle: Bundle.main)
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
    }

    func configure(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }
}
