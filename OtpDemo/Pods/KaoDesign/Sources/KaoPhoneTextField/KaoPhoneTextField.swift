//
//  KaoTextFieldInput.swift
//  KaoDesign
//
//  Created by Ramkrishna on 01/22/2020.
//

import UIKit

public class KaoPhoneTextFieldData {
    public var countryCode, textFieldText, placeHolder: String?
    public var countryIcon: String
    public var rightBtnTitle: String?
    public var isRightButtonHidden: Bool = false

    public init(_ countryCode: String, _ countryIcon: String) {
        self.countryIcon = countryIcon
        self.countryCode = countryCode
    }
}



public enum Validation {
    case success
    case failure(String)
}

public protocol KaoPhoneTextFieldDelegate: class {
    func handleEvent(_ event: TextEvent)
}

public class KaoPhoneTextField: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var leftAccessoryIcon: UIImageView!

    @IBOutlet weak var labelPlaceHolder: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet private weak var cardViewTrailing: NSLayoutConstraint!
    @IBOutlet private weak var cardViewLeading: NSLayoutConstraint!
    @IBOutlet private weak var cardViewTop: NSLayoutConstraint!
    @IBOutlet private weak var cardViewBottom: NSLayoutConstraint!
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var errorContentView: UIView!
    @IBOutlet private weak var errorLabel: KaoLabel!
    @IBOutlet private weak var errorLabelBottom: KaoLabel!

    @IBOutlet weak var rightButtonContainer: UIStackView!
    @IBOutlet private weak var verticalBorder: UIView!
    private var contentView: UIView!
    private weak var delegate: KaoPhoneTextFieldDelegate?
    public var rightButtonTapped: (() -> Void)?

    private var placeHolder: String!
    private var titleText: String!
    private var kaoPhoneTextFieldStyle: KaoPhoneTextFieldStyle  = .vendor

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
        textField.keyboardType = .numberPad
        textField.font = UIFont.kaoFont(style: .regular, size: 16)
        textField.clearButtonMode = .whileEditing
        textField.tintColor = .kaoColor(.dustyGray2)

        titleLabel.font = UIFont.kaoFont(style: .regular, size: 16)
        titleLabel.textColor = .kaoColor(.black)

        cardView.addCornerRadius()
        errorContentView.isHidden = true
        rightButton.isHidden = true
        labelPlaceHolder.isHidden = true
        errorLabelBottom.isHidden = true
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoPhoneTextField")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
    }

    func setDelegate(_ delegate: KaoPhoneTextFieldDelegate) {
        self.delegate = delegate
    }

    public func configure(_ data: KaoPhoneTextFieldData, _ delegate: KaoPhoneTextFieldDelegate) {
        setDelegate(delegate)
        titleLabel.text = data.countryCode
        textField.text = data.textFieldText
        if let placeHolder = data.placeHolder{
            labelPlaceHolder.text = "  " + placeHolder + "  "
        }
        configureAccessory(leftIcon: data.countryIcon)
        if !data.isRightButtonHidden {
            configureRightButton(data.rightBtnTitle)
        }
    }

    public func configureError(_ errorTitle: String? = "") {

        if(kaoPhoneTextFieldStyle == .customer){
            errorLabelBottom.isHidden = false
            cardView.addBorderLine(width: 1, color: .kaoColor(.errorRed))
            errorLabelBottom.font = UIFont.kaoFont(style: .regular, size: 12)
            errorLabelBottom.textColor = UIColor.kaoColor(.errorRed)
            errorLabelBottom.text = errorTitle
            labelPlaceHolder.textColor = .kaoColor(.errorRed)
        }else{
            errorLabel.font = UIFont.kaoFont(style: .regular, size: 12)
            errorLabel.textColor = UIColor.kaoColor(.errorRed)
            errorLabel.text = errorTitle
            errorContentView.isHidden = false
        }
    }

    public func configureStyle(kaoPhoneTextFieldStyle: KaoPhoneTextFieldStyle){
        self.kaoPhoneTextFieldStyle = kaoPhoneTextFieldStyle
        if(kaoPhoneTextFieldStyle == .customer){
            cardView.backgroundColor = .white
            cardView.addBorderLine(width: 1, color: .kaoColor(.vividBlue))
            labelPlaceHolder.isHidden = false
            labelPlaceHolder.textColor = .kaoColor(.vividBlue)
            verticalBorder.backgroundColor = .kaoColor(.borderGrey)
            textField.clearButtonTintColor = .kaoColor(.vividBlue)
            textField.tintColor = .kaoColor(.vividBlue)
            rightButtonContainer.isHidden = true
            rightButton.isHidden = true

            rightButtonContainer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                rightButtonContainer.widthAnchor.constraint(equalToConstant: 1)
            ])
        }
    }

    func clearError() {

        if(kaoPhoneTextFieldStyle == .customer){
            errorLabelBottom.isHidden = true
            cardView.addBorderLine(width: 1, color: .kaoColor(.vividBlue))
            labelPlaceHolder.textColor = .kaoColor(.vividBlue)
        }else{
            errorContentView.isHidden = true
        }
    }

    public func clear() {
        textField.text = ""
    }

    public func configureEdge(_ edge: UIEdgeInsets) {
        cardViewTop.constant = edge.top
        cardViewBottom.constant = edge.bottom
        cardViewLeading.constant = edge.left
        cardViewTrailing.constant = edge.right
    }

    func configureAccessory(leftIcon: String?) {
        if let leftIconName = leftIcon {
            leftAccessoryIcon.isHidden = false
            leftAccessoryIcon.image = UIImage.imageFromDesignIos(leftIconName)
        } else {
            leftAccessoryIcon.isHidden = true
        }
        self.layoutIfNeeded()
    }

    public func configureRightButton(_ title: String?) {
        self.rightButton.isHidden = false
        self.rightButton.setTitle(title, for: .normal)
        self.rightButton.titleLabel?.font = .kaoFont(style: .regular, size: 14)
        self.rightButton.setTitleColor(.kaoColor(.dimGray), for: .normal)
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
        clearError()
        delegate?.handleEvent(.textDidChange(sender.text))
    }

    @IBAction func didTapOnView(_ sender: Any) {
        textField.becomeFirstResponder()
    }

    @IBAction func rightButtonTapped(_ sender: Any) {
        rightButtonTapped?()
    }
}

extension KaoPhoneTextField: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate?.handleEvent(.textCharacterChanged(textField.text))
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.handleEvent(.textBeginEditing(textField.text))
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.handleEvent(.textEndEditing(textField.text))
    }

    public func textFieldBecomeFirstResponder() {
        self.textField.becomeFirstResponder()
    }

    public func selectTextRange() {
        self.textField.selectedTextRange = self.textField.textRange(from: self.textField.beginningOfDocument, to: self.textField.endOfDocument)
    }
}
