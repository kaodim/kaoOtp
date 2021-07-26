//
//  PaymentCalculaorCell.swift
//  KaoDesign
//
//  Created by Ramkrishna on 20/05/2020.
//

import UIKit

class PaymentCalculatorCell: UITableViewCell, NibLoadableView {

    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var cellTitleLabel: UILabel!
    @IBOutlet private weak var cellBtn: UIButton!
    @IBOutlet private weak var leftTitleTextView: UITextView!
    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var rightLabel: UILabel!
    @IBOutlet weak var seperatorLineHeight: NSLayoutConstraint!

    @IBOutlet weak var topSpaceLineSepertor: NSLayoutConstraint!
    @IBOutlet weak var topSeperatorLineHeight: NSLayoutConstraint!

    @IBOutlet weak var leftLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightLabelBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var topViewLineSeperatorConstrint: NSLayoutConstraint!
    @IBOutlet weak var topViewLabelBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var leftTextView: UITextView!
    @IBOutlet weak var leftIcon: UIImageView!

    var isLastCell: Bool = false
    var btnTapped: (() -> Void)?
    var linkTapped: ((_ URL: URL, _ source: UIView) -> Void)?
    var leftIconTapped: ((_ url: URL, _ source: UIView) -> Void)?
    var leftIconURL: URL? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        leftTextView.delegate = self
        leftTitleTextView.delegate = self
        
        leftTitleTextView.textContainerInset = .zero
        leftTitleTextView.textContainer.lineFragmentPadding = 0
        
        leftTextView.textContainerInset = .zero
        leftTextView.textContainer.lineFragmentPadding = 0

        self.cellBtn.setTitleColor(UIColor.kaoColor(.vividBlue), for: .normal)
        self.cellBtn.titleLabel?.font = .kaoFont(style: .regular, size: 14)

        self.cellTitleLabel.textColor = .kaoColor(.black)
        self.cellTitleLabel.font = .kaoFont(style: .regular, size: 15)
        selectionStyle = .none
    }

    func configure(_ cellData: PaymentCalculaorCellData, _ isFirstRow: Bool) {

        if let icon = cellData.leftIcon {
            leftIcon.image = icon
            leftIcon.isHidden = false
            leftIconURL = cellData.leftIconURL
        } else {
            leftIcon.isHidden = true
        }

        leftTitleTextView.attributedText = cellData.leftTitleLabel
        leftTitleTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.vividBlue)]

        var linkAttExist = false
        if let leftLabelText = cellData.leftLabel {
            self.leftLabel.isHidden = false
            let nsString: NSString = leftLabelText.string as NSString
            let nsRange = NSMakeRange(0, nsString.length)
            leftLabelText.enumerateAttribute(.link, in: nsRange, options: []) { (item, range, ff) in
                if item != nil {
                    linkAttExist = true
                }

                if linkAttExist {
                    leftTextView.isHidden = false
                    self.leftLabel.isHidden = true
                    leftTextView.attributedText = cellData.leftLabel
                    leftTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.vividBlue)]
                } else {
                    leftTextView.isHidden = true
                    self.leftLabel.isHidden = false
                    self.leftLabel.attributedText = cellData.leftLabel
                }
            }
        } else {
            leftLabel.isHidden = true
            leftTextView.isHidden = true
        }

        self.setupSeperatorLine(cellData, isFirstRow)
        self.rightLabel.attributedText = cellData.rightLabel
        self.topView.isHidden = !isFirstRow
    }

    func setupSeperatorLine(_ cellData: PaymentCalculaorCellData, _ isFirstRow: Bool) {
        self.seperatorLineHeight.constant = cellData.showSeperatorLine ? 1 : 0
        self.topSeperatorLineHeight.constant = cellData.showTopSeperatorLine ? 1 : 0

        if !cellData.showSeperatorLine {
            leftLabelBottomConstraint.constant = 0
            rightLabelBottomConstraint.constant = 0
        } else {
            leftLabelBottomConstraint.constant = 16
            rightLabelBottomConstraint.constant = 16
        }

        if cellData.showTopSeperatorLine && !cellData.showSeperatorLine {
            topSpaceLineSepertor.constant = 16
            leftLabelBottomConstraint.constant = 16
            rightLabelBottomConstraint.constant = 16
        } else {
            topSpaceLineSepertor.constant = 0
        }

        if cellData.showTopViewLineSeperator {
            topViewLineSeperatorConstrint.constant = 1
            topViewLabelBottomConstraint.constant = 12
        } else {
            topViewLineSeperatorConstrint.constant = 0
            topViewLabelBottomConstraint.constant = -6
        }

    }

    func configureCellHeader(_ cellTitleText: NSAttributedString, btnTitle: String?, btnTapped: @escaping (() -> Void)) {
        self.topView.isHidden = false
        self.cellTitleLabel.attributedText = cellTitleText
        self.cellBtn.setTitle(btnTitle ?? "", for: .normal)
        self.btnTapped = {
            btnTapped()
        }

        self.cellTitleLabel.font = .kaoFont(style: .regular, size: 15)
        self.cellTitleLabel.textColor = .kaoColor(.black)

        self.cellBtn.setTitleColor(UIColor.kaoColor(.vividBlue), for: .normal)
        self.cellBtn.titleLabel?.font = .kaoFont(style: .regular, size: 14)
    }

    func hideTopView() {
        self.topView.isHidden = true
    }

    @IBAction func leftIconTapped(_ sender: UIButton) {
        if let url = leftIconURL {
            self.leftIconTapped?(url, sender)
        }
    }

    @IBAction func buttonTapped(_ sender: Any) {
        self.btnTapped?()
    }
}

extension PaymentCalculatorCell: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        self.linkTapped?(URL, textView)
        return false
    }
}
