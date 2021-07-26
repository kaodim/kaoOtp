//
//  AnswerTableViewCell.swift
//  KaoDesign
//
//  Created by Ramkrishna on 27/05/2019.
//

import UIKit

public class AnswerTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet private weak var titleLabel: KaoLabel!
    @IBOutlet private weak var bulletView: UIView!
    @IBOutlet private weak var bulletLabel: KaoLabel!
    @IBOutlet private weak var subtitleTextView: UITextView!
    @IBOutlet private weak var editButton: UIButton!
    
    public var editButtonTapped: (() -> Void)?
    public var linkTapped: (() -> Void)?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureViews()
    }

    private func configureViews() {
        titleLabel.font = .kaoFont(style: .regular, size: 15.0)
        titleLabel.textColor = .kaoColor(.greyishBrown)
        
        subtitleTextView.delegate = self
        subtitleTextView.textContainerInset = .zero
        subtitleTextView.textContainer.lineFragmentPadding = 0

        subtitleTextView.font = .kaoFont(style: .regular, size: 15.0)
        subtitleTextView.textColor = .kaoColor(.black)

        bulletView.backgroundColor = UIColor.kaoColor(.grayChateau)
        bulletView.makeRoundCorner()

        bulletLabel.font = .kaoFont(style: .semibold, size: 10.0)
        bulletLabel.textColor = .white

        editButton.isHidden = true
    }
    
    public func configure(_ title: String, subTitle: String? = nil, number: String? = nil, editable: Bool? = false) {
        self.titleLabel.text = title

        if let subTitle = subTitle {
            self.subtitleTextView.text = subTitle
        }

        configureBullet(number)
        configureButton(isEditing: editable)
        setNeedsLayout()
    }

    public func configure(_ title: NSAttributedString, subTitle: NSAttributedString? = nil, number: String? = nil, editable: Bool? = false) {
        self.titleLabel.attributedText = title

        if let subTitle = subTitle {
            self.subtitleTextView.attributedText = subTitle
        }

        configureBullet(number)
        configureButton(isEditing: editable)
        setNeedsLayout()
    }

    private func configureBullet(_ number: String?) {
        number == nil ? (bulletView.isHidden = true) : (bulletView.isHidden = false)
        bulletLabel.text = number
    }

    private func configureButton(isEditing: Bool?) {
        (isEditing ?? false) ? (editButton.isHidden = false) : (editButton.isHidden = true)
    }
    
    @IBAction func editButonTapped(_ sender: Any) {
        self.editButtonTapped?()
    }
}

extension AnswerTableViewCell: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        self.linkTapped?()
        return false
    }
}
