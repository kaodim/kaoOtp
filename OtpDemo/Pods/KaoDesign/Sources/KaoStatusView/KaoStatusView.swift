//
//  KaoStatusView.swift
//  KaodimIosDesign
//
//  Created by augustius cokroe on 23/07/2018.
//  Copyright © 2018 kaodim. All rights reserved.
//

import Foundation
import UIKit

public class KaoStatusView: UIView {

    private var contentView: UIView!
    @IBOutlet private weak var seperatorLine: UIView!
    @IBOutlet weak var statusContentStackView: UIStackView!

    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!

    var kaoStatus: [KaoStatus] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoStatusView")
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

    public func configureStatus(kaoStatus: [KaoStatus], seperatorHidden: Bool? = true,showLastLine: Bool) {
        seperatorLine.isHidden = seperatorHidden ?? true
        statusContentStackView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        var statusViews = [StatusView]()
        for (index, status) in kaoStatus.enumerated() {
            if index == 0 {
                status.position = .first
            } else if index == kaoStatus.indices.last {
                status.position = .last
            } else {
                status.position = .middle
            }

            let view = StatusView()
            view.configure(status: status,showLastLine: showLastLine)
            statusViews.append(view)
            statusContentStackView.addArrangedSubview(view)
        }

        for (index, status) in kaoStatus.enumerated() {
            if index > 0 {
                if kaoStatus.indices.contains(index - 1) {
                    let currentStatusView = statusViews[index]
                    let previousStatusView = statusViews[index - 1]

                    if status.isSelected == .selected {
                        currentStatusView.isEnableLeftLine(enable: true)
                        previousStatusView.isEnableRightLine(enable: true)
                    }

                }
            }
        }
    }

    public func addPadding(_ top: CGFloat, _ bottom: CGFloat, _ leading: CGFloat, _ trailing: CGFloat) {
        self.top.constant = top
        self.bottom.constant = bottom
        self.leading.constant = leading
        self.trailing.constant = trailing
    }

}
