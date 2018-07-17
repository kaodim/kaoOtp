//
//  OtpBottomView.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

class OtpBottomView: UIView {
    
    @IBOutlet private weak var nextButton: UIButton!

    private var contentView: UIView!
    var nextButtonAttr = CustomButtonAttributes() {
        didSet {
            nextButton.titleLabel?.font = nextButtonAttr.font
        }
    }
    var didTapNext: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UINib(nibName: "OtpBottomView", bundle: Bundle.main)
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
        nextButton.layer.cornerRadius = nextButton.bounds.height/2
        nextButton.layer.masksToBounds = true
        nextButton.clipsToBounds = true
    }

    @IBAction private func nextTapped() {
        didTapNext?()
    }

    func configure(title: String) {
        nextButton.setTitle(title, for: .normal)
    }

    func enableNextButton(enable: Bool = true) {
        nextButton.isEnabled = enable
        nextButton.backgroundColor = enable ? nextButtonAttr.color : nextButtonAttr.disableColor
    }
}
