//
//  KaoTextFieldInput.swift
//  KaoDesign
//
//  Created by Ramkrishna on 01/22/2020.
//

import UIKit

public enum TextFieldControlState {
    case inactive
    case focused
    case activated
    case filled
    case readOnly
    case disabled
}

public enum TextEvent {
    case textDidChange(_ text: String?)
    case textBeginEditing(_ text: String?)
    case textEndEditing(_ text: String?)
    case textCharacterChanged(_ text: String?)
}

public class KaoTextFieldInputData {
    public var titleLabel, errorTitle, textFieldText, placeHolder: String?
    public var leftIcon, rightIcon: String?
    public var state: TextFieldControlState = .inactive
    public var isSecureTextEntry: Bool = false
    public var rightBtnTitle: String?
    public var isRightButtonHidden: Bool = true
    public var isEditable = true
    public var capitalizationType: UITextAutocapitalizationType = .sentences
    public var keyboardType: UIKeyboardType = .default
    public var isAllowedEmptySpace = true
    public init() { }
}

public protocol KaoTextFieldInputDelegate: class {
    func handleEvent(_ event: TextEvent)
}

public class KaoTextFieldInput: UIView {

    @IBOutlet private weak var titleLabel: KaoLabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var errorLabel: KaoLabel!

    @IBOutlet private weak var leftAccessoryIcon: UIButton!

    @IBOutlet private weak var rightAccessoryIcon: UIButton!

    @IBOutlet private weak var textContentView: UIView!
    @IBOutlet private weak var errorContentView: UIView!
    @IBOutlet private weak var titleContentView: UIView!

    @IBOutlet private weak var cardViewTrailing: NSLayoutConstraint!
    @IBOutlet private weak var cardViewLeading: NSLayoutConstraint!
    @IBOutlet private weak var cardViewTop: NSLayoutConstraint!
    @IBOutlet private weak var cardViewBottom: NSLayoutConstraint!

    private var descriptionState: DescriptionState = .description

    private var contentView: UIView!
    private var delegate: KaoTextFieldInputDelegate!
    private var state: TextFieldControlState! {
        didSet {
            configureForState(state)
        }
    }

    private var placeHolder: String!
    private var titleText: String!
    private var textFieldtag: Int?


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
        textField.autocapitalizationType = .sentences
        textField.font = UIFont.kaoFont(style: .regular, size: 16)
        textField.clearButtonMode = .whileEditing
        textField.tintColor = .kaoColor(.dustyGray2)
        errorLabel.isHidden = true
        errorContentView.isHidden = true
        rightAccessoryIcon.isHidden = true
    }

    func setUpTitleUI(_ color: UIColor = UIColor.kaoColor(.dimGray)) {
        titleLabel.font = UIFont.kaoFont(style: .medium, size: 12)
        titleLabel.textColor = color
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoTextFieldInput")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
    }

    func setDelegate(_ delegate: KaoTextFieldInputDelegate) {
        self.delegate = delegate
    }

    public func configure(_ data: KaoTextFieldInputData, _ delegate: KaoTextFieldInputDelegate) {
        setDelegate(delegate)
        titleText = data.titleLabel?.firstCharacterUpperCase()
        placeHolder = data.placeHolder?.firstCharacterUpperCase()
        textField.text = data.textFieldText
        textField.isSecureTextEntry = data.isSecureTextEntry
        state = data.state
        configureAccessory(leftIcon: data.leftIcon, rightIcon: data.rightIcon)
        if let error = data.errorTitle {
            configureErrorContentUI(error)
        }
        toggleStates(false)
    }

    public func configureEdge(_ edge: UIEdgeInsets) {
        cardViewTop.constant = edge.top
        cardViewBottom.constant = edge.bottom
        cardViewLeading.constant = edge.left
        cardViewTrailing.constant = edge.right
    }

    private func configureForState(_ state: TextFieldControlState) {
        switch state {
        case .inactive:
            configureInActiveState()
        case .focused:
            configureFocusedState()
        case .activated:
            configureActivatedState()
        case .filled:
            configureFilledState()
        case .readOnly:
            configureReadOnlyState()
        case .disabled:
            configureDisableState()
        }
    }

    func configureInActiveState() {
        setupContentViewUI(UIColor.kaoColor(.borderGrey), true)
    }

    func configureFocusedState() {

        // Text field focus colors and styles
        setupContentViewUI(UIColor.kaoColor(.vividBlue), false)
        setUpTitleUI(UIColor.kaoColor(.vividBlue))

        // Other UI styles on focus
        errorLabel.isHidden = true
    }

    func configureActivatedState() {
        setupContentViewUI(UIColor.kaoColor(.vividBlue), false)
        setUpTitleUI(UIColor.kaoColor(.vividBlue))
        errorLabel.isHidden = true
    }

    func configureFilledState() {
        setupContentViewUI(UIColor.kaoColor(.borderGrey), false)
        setUpTitleUI(UIColor.kaoColor(.dimGray))
        errorLabel.isHidden = true
    }

    func configureReadOnlyState() {

    }

    func configureDisableState() {

    }

    func setupContentViewUI(_ color: UIColor = UIColor.kaoColor(.borderGrey), _ isHidden: Bool) {
        titleContentView.isHidden = isHidden
        titleLabel.isHidden = isHidden
        textContentView.addBorderLine(width: 1, color: color)
        textContentView.addCornerRadius(4)

        if isHidden {
            textField.attributedPlaceholder = attributedPlaceHolder(titleText)
        } else {
            textField.placeholder = placeHolder
            titleLabel.text = titleText
        }
    }

    func configureAccessory(leftIcon: String?, rightIcon: String?) {
        if let leftIconName = leftIcon {
            leftAccessoryIcon.isHidden = false
            leftAccessoryIcon.setImage(UIImage.imageFromDesignIos(leftIconName), for: .normal)
        } else {
            leftAccessoryIcon.isHidden = true
        }

        if let rightIconName = rightIcon {
            rightAccessoryIcon.isHidden = false
            rightAccessoryIcon.setImage(UIImage.imageFromDesignIos(rightIconName), for: .normal)
        } else {
            rightAccessoryIcon.isHidden = true
        }

        self.layoutIfNeeded()
    }

    func configureErrorContentUI(_ errorTitle: String? = "") {
        titleLabel.font = UIFont.kaoFont(style: .regular, size: 12)
        titleLabel.textColor = UIColor.kaoColor(.errorRed)

        errorLabel.font = UIFont.kaoFont(style: .regular, size: 12)
        errorLabel.textColor = UIColor.kaoColor(.errorRed)
        errorLabel.isHidden = false
        errorLabel.text = errorTitle
        errorContentView.isHidden = false
        setupContentViewUI(UIColor.kaoColor(.errorRed), state == .inactive)
    }

    func toggleStates(_ isFocused: Bool) {
        let isTextFieldEmpty = (textField.text?.isEmpty ?? true)
        if !isFocused && isTextFieldEmpty {
            state = .inactive
        } else if !isFocused && !isTextFieldEmpty {
            state = .filled
        } else {
            state = .focused
        }
    }

    func attributedPlaceHolder(_ placeHolder: String) -> NSAttributedString {
        return NSAttributedString.init(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.dustyGray2)])
    }

    // MARK: - Textfield

    public func configureTextFieldTag(_ row: Int) {
        textField.tag = row
    }

    public func setUserInteraction(_ enabled: Bool) {
        textField.isUserInteractionEnabled = enabled
    }

    public func configureTextFieldSecure(_ secure: Bool) {
        textField.isSecureTextEntry = secure
    }

    open func configureTextFieldClear(_ clearButton: UITextField.ViewMode) {
        textField.clearButtonMode = clearButton
    }

    @IBAction func textFieldChanged(_ sender: UITextField) {
        delegate.handleEvent(.textDidChange(sender.text))
    }

    @IBAction func didTapOnView(_ sender: Any) {
        textField.becomeFirstResponder()
    }
}

extension KaoTextFieldInput: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate.handleEvent(.textCharacterChanged(textField.text))
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        toggleStates(true)
        delegate.handleEvent(.textBeginEditing(textField.text))
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        toggleStates(false)
        delegate.handleEvent(.textEndEditing(textField.text))
    }

    public func textFieldBecomeFirstResponder() {
        self.textField.becomeFirstResponder()
    }

    public func selectTextRange() {
        self.textField.selectedTextRange = self.textField.textRange(from: self.textField.beginningOfDocument, to: self.textField.endOfDocument)
    }
}
