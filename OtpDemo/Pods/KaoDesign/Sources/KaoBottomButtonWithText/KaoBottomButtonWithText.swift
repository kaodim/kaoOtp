//
//  KaoBottomButtonWithText.swift
//  Kaodim
//
//  Created by Kelvin Tan on 9/26/19.
//  Copyright © 2019 Kaodim Sdn Bhd. All rights reserved.
//

import UIKit

public class KaoBottomButtonWithText: UIView {

	private var containerView: UIView!

	@IBOutlet private weak var button: KaoButton!
	@IBOutlet private weak var textView: UITextView!
	@IBOutlet private weak var textViewTop: NSLayoutConstraint!
	@IBOutlet private weak var textViewLeading: NSLayoutConstraint!
	@IBOutlet private weak var textViewTrailing: NSLayoutConstraint!
	@IBOutlet private weak var textViewBottom: NSLayoutConstraint!
	@IBOutlet private weak var viewBottom: NSLayoutConstraint!
	@IBOutlet private weak var viewLeading: NSLayoutConstraint!
	@IBOutlet private weak var viewTrailing: NSLayoutConstraint!
	@IBOutlet private weak var viewTop: NSLayoutConstraint!

	public var buttonTap: (() -> Void)?
	public var linkTapped: ((_ URL: URL) -> Void)?
    public var enableButton: Bool = true {
        didSet {
            button.isEnabled = enableButton
        }
    }

	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		setupViews()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupViews()
	}

	private func setupViews() {
		containerView = loadViewFromNib()
		containerView.frame = bounds
		containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(containerView)
		configureView()
	}

	private func configureView() {
		button.addCornerRadius(4)
        button.setBackgroundColor(color: UIColor.kaoColor(.crimson), forState: UIControl.State.normal)
		button.setTitleColor(.white, for: .highlighted)
		textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
	}

	private func loadViewFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoBottomButtonWithText")
		guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
			fatalError("Nib not found.")
		}
		return view
	}

	public func configureTextViewEdges(_ edge: UIEdgeInsets) {
		textViewTop.constant = edge.top
		textViewBottom.constant = edge.bottom
		textViewLeading.constant = edge.left
		textViewTrailing.constant = edge.right
	}

	public func configureEdges(_ edge: UIEdgeInsets) {
		viewTop.constant = edge.top
		viewBottom.constant = edge.bottom
		viewLeading.constant = edge.left
		viewTrailing.constant = edge.right
	}

	public func configureButton(_ title: String) {
		button.setTitle(title, for: .normal)
        button.setTitle(title, for: .disabled)
        button.setTitle(title, for: .highlighted)
	}

    public func isButtonEnabled(_ isEnabled: Bool) {
        button.isEnabled = isEnabled
    }

    public func configureDescription(_ attributedString: NSAttributedString, linkAttributes: [NSAttributedString.Key : Any] = [:]) {
		textView.delegate = self
		textView.attributedText = attributedString
        textView.linkTextAttributes = linkAttributes
		textView.textAlignment = .center
	}

	@IBAction func buttonDidTapped() {
		buttonTap?()
	}
}

extension KaoBottomButtonWithText: UITextViewDelegate {
	public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
		self.linkTapped?(URL)
		return false
	}
}
