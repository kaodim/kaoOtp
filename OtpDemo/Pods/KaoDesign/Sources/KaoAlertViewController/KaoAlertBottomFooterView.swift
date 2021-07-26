//
//  KaoAlertBottomFooterView.swift
//  Kaodim
//
//  Created by Ramkrishna on 27/06/2019.
//  Copyright © 2019 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class KaoAlertBottomFooterView: UIView {

    @IBOutlet private var cancel: KaoButton!
    private var contentView: UIView!

    public var cancelTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func configureViews() {
        contentView = loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)

        cancel.configure(type: .dismiss, size: 16)

    }

    private func loadViewFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoAlertBottomFooterView")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    public func configureTitle(title: String) {
        cancel.setTitle(title, for: .normal)
    }

    // MARK: -  Actions
    @IBAction func closeTapped(_ sender: Any) {
        self.cancelTapped?()
    }
}
