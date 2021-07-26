//
//  KaoTextField.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 7/17/19.
//

import UIKit

enum DescriptionState {
    case description, error
}

public class KaoTextField: UIView {

    @IBOutlet private weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var stackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textFieldView: UIView!
    @IBOutlet private weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var alertIcon: UIImageView!
    @IBOutlet private weak var descriptionView: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var descriptionLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dividerView: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var iconButton: UIButton!
    @IBOutlet private weak var leftIcon: UIImageView!
    @IBOutlet private weak var rightIcon: UIImageView!
    @IBOutlet private weak var leftIconWidth: NSLayoutConstraint!
    @IBOutlet private weak var leftIconLeading: NSLayoutConstraint!
    @IBOutlet private weak var rightButton: UIButton!

    @IBOutlet weak var rightButtonWidthConstraint: NSLayoutConstraint!
    public var handleTextChanged: ((_ text: String, _ index: Int) -> Void)?
    public var textBeginEditing: ((_ textField: UITextField) -> Void)?
    public var textEndEditing: ((_ textField: UITextField) -> Void)?
    public var textCharacterChange: ((_ textField: UITextField) -> Void)?
    public var reloadData: (() -> Void)?
    public var rightButtonTapped: (() -> Void)?

    private var characterLimit: Int?
    private var descriptionState: DescriptionState = .description
    private var capitalizationType: UITextAutocapitalizationType = .sentences
    private var contentView: UIView!
    private weak var delegate: KaoTextFieldInputDelegate?

    var isSecurePassword: Bool = false
    var isSecurePasswordTextField: Bool = false

    private var isAllowedEmptySpace = true
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
        textField.delegate = self
        textField.autocapitalizationType = capitalizationType
        textFieldView.addCornerRadius(4)
        clearError()
        showLeftIcon(false)
        rightIcon.isHidden = true
        rightButton.isHidden = true
        rightButtonWidthConstraint.constant = 0
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoTextField")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Edges
    public func configureEdges(topConstraint: CGFloat, bottomConstraint: CGFloat, leadingConstraint: CGFloat, trailingConstraint: CGFloat) {
        stackViewTopConstraint.constant = topConstraint
        stackViewBottomConstraint.constant = bottomConstraint
        stackViewLeadingConstraint.constant = leadingConstraint
        stackViewTrailingConstraint.constant = trailingConstraint
    }

    public func configure(_ data: KaoTextFieldInputData, _ delegate: KaoTextFieldInputDelegate?) {
        setDelegate(delegate)
        titleLabel.text = data.titleLabel
        textField.placeholder = data.placeHolder
        textField.autocapitalizationType = data.capitalizationType
        textField.keyboardType = data.keyboardType
        if let text = data.textFieldText, !text.isEmpty {
            textField.text = text
            floatTitle()
        } else {
            unfloatTitle()
            textField.text = nil
        }

        configureAccessory(icon: data.leftIcon)
        if let error = data.errorTitle {
            configureErrorDescription(error)
        }

        isSecurePasswordTextField = data.isSecureTextEntry
        isSecurePassword = data.isSecureTextEntry

        isAllowedEmptySpace = data.isAllowedEmptySpace

        if let icon = data.leftIcon {
            configureLeftIcon(image: UIImage.imageFromDesignIos(icon))
        }

        if let icon = data.rightIcon {
            configureRightIcon(image: UIImage.imageFromDesignIos(icon))
        }

        if !data.isRightButtonHidden {
            rightButtonWidthConstraint.constant = 50
            configureRightButton(data.rightBtnTitle)
        }

        self.descriptionLabel.text = nil
        self.descriptionView.isHidden = true

        setUserInteraction(data.isEditable)
    }

    func setDelegate(_ delegate: KaoTextFieldInputDelegate?) {
        self.delegate = delegate
    }

    @objc func showPassword(tapGestureRecognizer: UITapGestureRecognizer) {
        isSecurePassword.toggle()
        self.configureTextFieldSecure(isSecurePassword)
    }

    // MARK: - Scenario
    public func configureErrorDescription(_ text: String) {
        configureTextFieldClear(.never)
        descriptionView.isHidden = false
        descriptionLabel.isHidden = false
        configureDescription(text, UIColor.kaoColor(.errorRed), 10)
        configureDividerColor(UIColor.kaoColor(.errorRed))
        alertIcon.image = UIImage.imageFromDesignIos("ic_formerror")
        alertIcon.tintColor = UIColor.kaoColor(.errorRed)
        alertIcon.isHidden = false
        descriptionState = .error
        //        configureTextFieldIcon("ic_formerror", color: UIColor.kaoColor(.errorRed))
    }

    public func configureLeftIcon(image: UIImage?, color: UIColor? = nil) {
        showLeftIcon(true)
        leftIcon.image = image

        if let color = color {
            leftIcon.tintColor = color
        }
    }

    public func configureRightIcon(image: UIImage?, color: UIColor? = nil) {
        rightIcon.image = image
        rightIcon.tintColor = color
        rightIcon.isHidden = false
        rightIcon.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPassword(tapGestureRecognizer:)))
        rightIcon.addGestureRecognizer(tapGestureRecognizer)
    }

    public func showLeftIcon(_ show: Bool) {
        leftIcon.isHidden = !show
        leftIconWidth.constant = show ? 24 : 0
        leftIconLeading.constant = show ? 12 : 0
    }

    func configureAccessory(icon: String?) {
        if let leftIconName = icon {
            leftIcon.isHidden = false
            leftIcon.image = UIImage.imageFromDesignIos(leftIconName)
            leftIcon.tintColor = UIColor.kaoColor(.grayChateau)
        } else {
            leftIcon.isHidden = true
        }
    }

    public func clearError() {
        configureDividerColor(.lightGray)
        alertIcon.image = nil
        alertIcon.isHidden = true
        UIView.performWithoutAnimation {
            if self.descriptionState == .error {
                self.descriptionLabel.text = nil
                self.descriptionView.isHidden = true
            }
            reloadData?()
        }
    }

    public func configureCharacterLimit(limit: Int) {
        self.characterLimit = limit
        generateCharacterLabelText()
    }

    private func generateCharacterLabelText() {
        descriptionView.isHidden = false
        descriptionLabel.textAlignment = .right
        descriptionLabel.font = .kaoFont(style: .regular, size: 12)
        descriptionLabel.textColor = .kaoColor(.dimGray)
        if let currentCount = textField.text?.count, let limit = characterLimit {
            descriptionLabel.text = "\(currentCount)/\(limit)"
        }
    }

    private func configureTextFieldIcon(_ image: String = "ic_clearform", color: UIColor = UIColor.kaoColor(.alto)) {
        iconButton.tintColor = color
        iconButton.setImage(UIImage.imageFromDesignIos(image), for: .normal)
        iconButton.isHidden = false
    }

    private func configureSecureText(_ isSecureTextEntry: Bool) {
        if isSecureTextEntry {
            configureTextFieldSecure(isSecurePasswordTextField)
            configureSecureIcon(isSecureTextEntry)
            configureTextFieldClear(.never)
        } else if textField.text?.isEmpty ?? true {
            rightIcon.image = nil
        }
    }

    @IBAction func clearText() {
        clear()
    }

    public func clear() {
        textField.text = ""
    }

    // MARK: Icon
    public func configureIcon(_ image: String? = nil, _ color: UIColor = .black, _ hide: Bool = true) {
        alertIcon.image = UIImage(named: image ?? "")
        alertIcon.tintColor = color
        alertIcon.isHidden = hide
    }

    // MARK: - Divider
    public func configureDividerColor(_ color: UIColor) {
        dividerView.backgroundColor = color
    }

    // MARK: - Description
    public func configureDescription(_ text: String? = nil, _ color: UIColor? = nil, _ constant: CGFloat = 0) {
        descriptionState = .description
        descriptionView.isHidden = text == nil
        descriptionLabel.textColor = color
        descriptionLabel.text = text
        descriptionLeadingConstraint.constant = constant
    }

    // MARK: - Title
    public func configureTitle(_ text: String, _ color: UIColor = UIColor.kaoColor(.greyishBrown)) { titleLabel.text = text
        titleLabel.textColor = color
    }

    public func floatTitle(_ color: UIColor = UIColor.kaoColor(.dustyGray2)) {
        titleLabel.font = titleLabel.font?.withSize(12)
        titleLabel.textColor = color
        titleLabelTopConstraint.constant = 5
        titleLabelLeadingConstraint.constant = 10
    }

    public func floatTitleChange(_ title: String) {
        floatTitle()
        titleLabel.text = title
    }

    public func unfloatTitle() {
        titleLabelTopConstraint.constant = 19
        titleLabelLeadingConstraint.constant = 10
        titleLabel.font = titleLabel.font?.withSize(16)
        titleLabel.textColor = UIColor.kaoColor(.dustyGray2)
    }

    // MARK: - Textfield
    open func configureTextField(_ text: String, _ color: UIColor = .black, _ enable: Bool = true) {
        textField.text = text
        textField.textColor = color
        textField.isEnabled = enable
    }

    public func configureTextFieldTag(_ row: Int) {
        textField.tag = row
    }

    public func setUserInteraction(_ enabled: Bool) {
        textField.isUserInteractionEnabled = enabled
        if !enabled {
            disableTextField()
        }
    }

    func disableTextField() {
        titleLabel.textColor = UIColor.kaoColor(.textDisable)
        textField.textColor = UIColor.kaoColor(.textDisable)
        textFieldView.backgroundColor = .kaoColor(.disableBkgColor)
    }

    public func configureTextFieldSecure(_ secure: Bool) {
        let orginalText = textField.text
        textField.text = ""
        textField.isSecureTextEntry = secure
        textField.text = orginalText

        if isSecurePasswordTextField {
            configureSecureIcon(secure)
        }
    }

    func configureSecureIcon(_ secure: Bool) {
        configureRightIcon(image: secure ? UIImage.imageFromDesignIos("icon_mini_showpassword") : UIImage.imageFromDesignIos("icon_mini_hidepassword"), color: .kaoColor(.grayChateau))
    }

    public func configureRightButton(_ title: String?) {
        self.rightButton.isHidden = false
        self.rightButton.setTitle(title, for: .normal)
        self.rightButton.titleLabel?.font = .kaoFont(style: .regular, size: 14)
        self.rightButton.setTitleColor(.kaoColor(.dimGray), for: .normal)
    }

    open func configureTextFieldClear(_ clearButton: UITextField.ViewMode) {
        // isSecureTextEntry for password textfields, no need clear button
        if !isSecurePasswordTextField {
            textField.clearButtonMode = clearButton
        }
    }

    @IBAction func textFieldChanged(_ sender: UITextField) {
        handleTextChanged?(sender.text ?? "", sender.tag)
        delegate?.handleEvent(.textDidChange(sender.text))
    }

    @IBAction func didTapOnView(_ sender: Any) {
        textField.becomeFirstResponder()
    }

    @IBAction func rightButtonTapped(_ sender: Any) {
        rightButtonTapped?()
    }
}

extension KaoTextField: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        if !isAllowedEmptySpace, string.containsWhiteSpace() {
            return false
        }

        if let limit = characterLimit {
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under the limit
            return updatedText.count <= limit
        }

        textCharacterChange?(textField)
        clearError()
        configureTextFieldClear(.whileEditing)

        // Works only using models
        delegate?.handleEvent(.textCharacterChanged(textField.text))
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textBeginEditing?(textField)
        configureBeginAnimation()
        delegate?.handleEvent(.textBeginEditing(textField.text))
        configureSecureText(isSecurePasswordTextField)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        textEndEditing?(textField)
        if textField.text?.isEmpty ?? false {
            configureEndAnimation()
        }
        delegate?.handleEvent(.textEndEditing(textField.text))
        configureSecureText(false)
    }

    public func textFieldBecomeFirstResponder() {
        self.textField.becomeFirstResponder()
    }

    public func selectTextRange() {
        self.textField.selectedTextRange = self.textField.textRange(from: self.textField.beginningOfDocument, to: self.textField.endOfDocument)

    }

    private func configureBeginAnimation() {
        floatTitle()
        performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1))
    }

    private func configureEndAnimation() {
        unfloatTitle()
        performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1))
    }

    private func performAnimation(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.titleLabel.transform = transform
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
