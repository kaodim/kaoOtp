//
//  KaoSlideUpDialogView.swift
//  KaoDesign
//
//  Created by Ramkrishna on 27/05/2019.
//

import Foundation
import UIKit

public class KaoSlideUpDialogView: UIView {

    private var contentView: UIView!
    @IBOutlet private weak var topSpace: NSLayoutConstraint!
    @IBOutlet private weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet private weak var leadingSpace: NSLayoutConstraint!
    @IBOutlet private weak var trailingSpace: NSLayoutConstraint!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var kaoText: KaoTextField!
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var rightHeaderBtn: UIButton!
    @IBOutlet weak var button: KaoButton!
    @IBOutlet weak var bkgView: UIView!

    var inputString: String?
    var buttonTapped: ((_ text: String?) -> Void)?
    var cancelTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoSlideUpDialogView")
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

        bkgView.addCornerRadius(8)

        titleLabel.font = UIFont.kaoFont(style: .regular, size: 15)
        titleHeader.font = UIFont.kaoFont(style: .semibold, size: 16)
        rightHeaderBtn.titleLabel?.font = UIFont.kaoFont(style: .medium, size: 15)

        titleLabel.textColor = UIColor.kaoColor(.black)
        titleHeader.textColor = UIColor.kaoColor(.black)
        rightHeaderBtn.titleLabel?.textColor = UIColor.kaoColor(.vividBlue)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.kaoText.textFieldBecomeFirstResponder()
            self.kaoText.selectTextRange()
        }

        kaoText.handleTextChanged = { [weak self] (text, _) in
            self?.inputString = text
        }
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
        _ dismissTitle:String?) {
        self.titleHeader.text = headerTitle
        self.titleLabel.text = titleLabel
        self.button.setTitle(buttonTitle, for: .normal)
        self.kaoText.floatTitleChange(textFieldFloatTitle)
        self.kaoText.configureTextField(textFieldTitle)
        self.inputString = textFieldTitle
        self.rightHeaderBtn.setTitle(dismissTitle, for: .normal)
    }

    @IBAction func cancelTapped(_ sender: Any) {
        self.cancelTapped?()
    }
    @IBAction func buttonTapped(_ sender: Any) {
        self.buttonTapped?(inputString)
    }


}
