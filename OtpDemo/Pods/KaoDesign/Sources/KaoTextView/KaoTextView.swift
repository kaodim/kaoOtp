//
//  KaoTextView.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 11/25/19.
//

import UIKit

public class KaoTextView: UIView {

    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var textViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var leftIcon: UIImageView!
    @IBOutlet private weak var leftIconWidth: NSLayoutConstraint!
    @IBOutlet private weak var leftIconLeading: NSLayoutConstraint!
    @IBOutlet private weak var rightIcon: UIImageView!
    @IBOutlet weak var placeHolderLabel: UILabel!

    public var textCharacterChange: ((_ textView: UITextView) -> Void)?
    public var textBeginEditing: ((_ textView: UITextView) -> Void)?
    public var textEndEditing: ((_ textView: UITextView) -> Void)?
    public var textViewDidChange: ((_ textView: UITextView) -> Void)?

    public var adjustTextViewHeight: ((_ height: CGFloat) -> Void)?

    private var contentView: UIView!

    public var unfloatTitleColor = UIColor.kaoColor(.greyishBrown)
    public var floatTitleColor = UIColor.kaoColor(.dustyGray2)
    public var defaultTitleColor = UIColor.kaoColor(.greyishBrown)

    // Default max allowed characters
    private var maxAllowedChar: Int = 1000

    public var placeHolder: String = "" {
        didSet {
            addPlaceHolder(placeHolder)
            isPlaceHolderHidden(textView.text.count > 0)
        }
    }

    // MARK: - init methods
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    // MARK: - Setup UI
    private func setupViews() {
        contentView = loadFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
        setupUI()
    }

    private func setupUI() {
        textView.isScrollEnabled = false
        textView.delegate = self
        placeHolderLabel.font = .kaoFont(style: .regular, size: 16)
        placeHolderLabel.textColor = UIColor.kaoColor(.dustyGray2)
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoTextView")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    public func configure(data: KaoSlideUpTextViewDialogData) {
        self.floatTitleChange(data.textFieldFloatTitle)
        self.configureTitle(data.textFieldFloatTitle)
        self.setTextView(data.textFieldTitle)
        self.isScrollEnabled(true)

        if let image = UIImage.imageFromDesignIos("ic_mini_notes") {
            self.configureLeftIcon(image: image)
            self.configureLeftIconTint(color: UIColor.kaoColor(.grayChateau))
        }

        placeHolder = data.placeHolder
    }

    public func configureLeftIcon(image: UIImage) {
        showLeftIcon(true)
        leftIcon.image = image
    }

    public func configureLeftIconTint(color: UIColor) {
        leftIcon.tintColor = color
    }

    public func showLeftIcon(_ show: Bool) {
        leftIcon.isHidden = !show
        leftIconWidth.constant = show ? 24 : 0
        leftIconLeading.constant = show ? 12 : 0
    }

    public func configureTitle(_ text: String) {
        titleLabel.text = text
        titleLabel.textColor = defaultTitleColor
    }

    public func floatTitle() {
        titleLabel.font = titleLabel.font?.withSize(12)
        titleLabel.textColor = floatTitleColor
        titleLabelTopConstraint.constant = 5
        titleLabelLeadingConstraint.constant = 13
    }

    public func setTextView(_ text: String, color: UIColor = .black) {
        self.textView.text = text
        textView.textContainer.maximumNumberOfLines = 0
        textView.textContainer.lineBreakMode = .byTruncatingTail
        adjustHeight()
        floatTitle()
    }

    public func setTextView(color: UIColor = UIColor.kaoColor(.dustyGray2)) {
        self.textView.textColor = color
    }

    public func setTitleLabel(color: UIColor = UIColor.kaoColor(.dustyGray2)) {
        self.titleLabel.textColor = color
    }

    public func textViewEnabled(_ enabled: Bool) {
        if enabled {
            self.textView.isEditable = true
        } else {
            self.textView.isEditable = false
        }
    }

    public func floatTitleChange(_ title: String) {
        floatTitle()
        titleLabel.text = title
    }

    public func unfloatTitle() {
        titleLabelTopConstraint.constant = 19
        titleLabelLeadingConstraint.constant = 13
        titleLabel.font = titleLabel.font?.withSize(16)
        titleLabel.textColor = unfloatTitleColor
    }

    public func isScrollEnabled(_ enable: Bool) {
        textView.isScrollEnabled = enable
    }

    public func adjustTextViewTopSpace(_ constant: CGFloat) {
        textViewTopConstraint.constant = constant
    }

    public func textViewText() -> String {
        return textView.text
    }

    @IBAction func triggerTextView() {
        isScrollEnabled(false)
        textView.becomeFirstResponder()
    }

    public func textViewBecomeFirstResponder() {
        self.textView.becomeFirstResponder()
    }

    public func setMaxAllowedChar(_ maxAllowedChar: Int) {
        self.maxAllowedChar = maxAllowedChar
    }

    private func addPlaceHolder(_ text: String) {
        placeHolderLabel.text = text
    }

    private func isPlaceHolderHidden(_ isHidden: Bool) {
        placeHolderLabel.isHidden = isHidden
    }

    public func getText() -> String {
        textView.text
    }

}
extension KaoTextView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textCharacterChange?(textView)
        adjustHeight()

        guard let string = textView.text else { return true }
        let newLength = string.count + text.count - range.length
        return newLength <= maxAllowedChar
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        isScrollEnabled(false)
        textBeginEditing?(textView)
        configureBeginAnimation()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) { [weak self] in
            self?.isScrollEnabled(true)
        }
        adjustHeight()
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        textEndEditing?(textView)
        if textView.text?.isEmpty ?? false {
            configureEndAnimation()
        }
    }

    public func textViewDidChange(_ textView: UITextView) {
        textViewDidChange?(textView)
        isPlaceHolderHidden(textView.text.count > 0)
    }

    private func configureBeginAnimation() {
        floatTitle()
        performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1))
    }

    func adjustHeight() {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        adjustTextViewHeight?(newSize.height)
    }

    private func configureEndAnimation() {
        if placeHolder.isEmpty {
            unfloatTitle()
        }
        performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1))
    }

    private func performAnimation(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.titleLabel.transform = transform
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
