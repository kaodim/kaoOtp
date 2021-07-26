//
//  KaoSlideUpDialogView.swift
//  KaoDesign
//
//  Created by Ramkrishna on 27/05/2019.
//

import Foundation
import UIKit

public class KaoSlideUpTextViewDialog: UIView {

    private var contentView: UIView!
    @IBOutlet private weak var topSpace: NSLayoutConstraint!
    @IBOutlet private weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet private weak var leadingSpace: NSLayoutConstraint!
    @IBOutlet private weak var trailingSpace: NSLayoutConstraint!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var kaoTextView: KaoTextView!
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var charCountLabel: UILabel!

    var inputString: String?
    var textDidChange: ((_ text: String?) -> Void)?
    var cancelTapped: (() -> Void)?

    var maxAllowedCharCount: Int = 1000
    var minCharRequired: Int = 100

    var validateFields = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoSlideUpTextViewDialog")
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

        let width = UIScreen.main.bounds.width - 32
        titleLabel.preferredMaxLayoutWidth = width

        titleLabel.font = UIFont.kaoFont(style: .regular, size: 15)
        titleLabel.textColor = UIColor.kaoColor(.black)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.kaoTextView.textViewBecomeFirstResponder()
        }

        kaoTextView.textViewDidChange = { [weak self] textView in
            // Restrict to max allowed characters
            guard let maxAllowedCharCount = self?.maxAllowedCharCount else { return }
            self?.updateCount(textView.text.count)
            self?.textDidChange?(textView.text)
        }
    }

    private func updateCount(_ currentCount: Int) {
        let attributes = [
            NSAttributedString.Key.font: UIFont.kaoFont(style: .regular, size: 16),
            NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.dustyGray2)
        ]

        var colorAttribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.dustyGray2)
        ]

        if currentCount < minCharRequired && currentCount > 0 {
            colorAttribute = [NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.textRed)]
        } else if currentCount >= minCharRequired {
            colorAttribute = [NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.malachite)]
        }

        colorAttribute.merged(with: [NSAttributedString.Key.font: UIFont.kaoFont(style: .regular, size: 16)])
        let firstText = NSMutableAttributedString.init(string: "\(currentCount)", attributes: colorAttribute)
        let secondText = NSMutableAttributedString.init(string: "/\(maxAllowedCharCount)", attributes: attributes)

        firstText.append(secondText)
        charCountLabel.attributedText = firstText
    }

    public func configureEdge(_ edge: UIEdgeInsets) {
        topSpace.constant = edge.top
        bottomSpace.constant = edge.bottom
        leadingSpace.constant = edge.left
        trailingSpace.constant = edge.right
    }

    public func configureData(_ headerTitle: String?,
        _ titleLabel: String,
        _ textFieldFloatTitle: String,
        _ textFieldTitle: String,
        _ buttonTitle: String,
        _ dismissTitle: String?,
        _ minAllowedCharCount: Int,
        _ placeHolder: String) {
        self.titleLabel.text = titleLabel

        self.kaoTextView.floatTitleChange(textFieldFloatTitle)
        self.kaoTextView.configureTitle(textFieldFloatTitle)
        self.kaoTextView.setTextView(textFieldTitle)
        self.kaoTextView.isScrollEnabled(true)
        self.kaoTextView.placeHolder = placeHolder

        if let image = UIImage.imageFromDesignIos("ic_mini_notes") {
            self.kaoTextView.configureLeftIcon(image: image)
            self.kaoTextView.configureLeftIconTint(color: UIColor.kaoColor(.grayChateau))

        }
        self.inputString = textFieldTitle
        self.minCharRequired = minAllowedCharCount

        self.updateCount(kaoTextView.textViewText().count)
    }

}
