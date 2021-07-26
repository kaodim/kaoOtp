//
//  KaoNoSearchFound.swift
//  KaoDesign
//
//  Created by augustius cokroe on 26/11/2018.
//

import Foundation
import UIKit

public class KaoNoSearchFound: UIView {

    @IBOutlet private weak var emptyView: FooterActionView!

    private var contentView: UIView!
    public var searchAgainTapped: (() -> Void)?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func configureViews() {
        contentView = loadFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoNoSearchFound")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    public func configureNoResultView(_ message: String, _ btnTitle: String, _ linkBtnEnabled: Bool? = false, _ attrString: String? = nil) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes = [
            NSAttributedString.Key.font: UIFont.kaoFont(style: .regular, size: 16),
            NSAttributedString.Key.paragraphStyle: paragraph,
            NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.black)
        ]
        let attributedString = NSMutableAttributedString.init(string: message, attributes: attributes)

        if let searchText = attrString {
            attributedString.setAttributes([NSAttributedString.Key.font: UIFont.kaoFont(style: .medium, size: 16)], range: (message as NSString).range(of: searchText))
        }
        if linkBtnEnabled ?? false {
            emptyView.configure(attributedString, btnTitle)
        } else {
            emptyView.configure(attributedString, nil)
        }
        emptyView.buttonTapped = { [weak self] in
            self?.searchAgainTapped?()
        }
        emptyView.configure(edge: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }

}
