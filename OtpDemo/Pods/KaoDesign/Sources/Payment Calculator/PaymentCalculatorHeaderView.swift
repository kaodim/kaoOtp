//
//  PaymentCalculatorHeaderView.swift
//  KaoDesign
//
//  Created by Ramkrishna on 18/05/2020.
//

import UIKit

public struct PaymentCalculatorHeaderData {
    public let icon: UIImage?
    public let enterAmountTitle: String
    public var amount: String
    public let currency: String

    public init(
        icon: UIImage?,
        enterAmountTitle: String,
        amount: String,
        currency: String) {
        self.icon = icon
        self.enterAmountTitle = enterAmountTitle
        self.amount = amount
        self.currency = currency
    }

    public mutating func updateAmount(_ amount: String) {
        self.amount = amount
    }
}

open class PaymentCalculatorHeaderView: UIView {

    private var contentView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var shadowView: UIView!

    @IBOutlet weak var button: UIButton!

    @IBOutlet private weak var enterAmountLabel: UILabel!
    @IBOutlet private weak var editIcon: UIButton!

    @IBOutlet private weak var amountTextfield: UITextField!
    @IBOutlet private weak var currencyLabel: UILabel!


    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var amountTopLabelConstraint: NSLayoutConstraint!

    @IBOutlet weak var amountBottomConstraint: NSLayoutConstraint!


    public var buttonTapped: (() -> Void)?
    public var textChanged: ((_ amount: String?, _ formattedAmt: ((_ amount: String) -> Void)) -> Void)?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        contentView = loadFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)

        backgroundView.backgroundColor = .kaoColor(.crimson)
        shadowView.dropShadow(shadowRadius: 2, shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.2), shadowOffSet: CGSize(width: 0, height: 1), shadowOpacity: 0.3)

        enterAmountLabel.font = .kaoFont(style: .regular, size: 15)
        enterAmountLabel.textColor = .kaoColor(.dimGray)

        currencyLabel.font = .kaoFont(style: .semibold, size: 16)
        currencyLabel.textColor = .kaoColor(.dustyGray2)

        amountTextfield.font = .kaoFont(style: .semibold, size: 56)
        amountTextfield.textColor = .kaoColor(.black)
        amountTextfield.tintColor = .kaoColor(.cursorBlue)

        amountTextfield.delegate = self


        let placeholderAttributes = NSAttributedString(string: "0.00", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.dustyGray2),
            NSAttributedString.Key.font: UIFont.kaoFont(style: .semibold, size: 56)
            ])
        amountTextfield.attributedPlaceholder = placeholderAttributes
        amountTextfield.textAlignment = .right
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("PaymentCalculatorHeaderView")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    public func configureData(_ icon: UIImage?,
        _ enterAmountTitle: String,
        _ currency: String,
        _ amount: String,
        _ iconTapped: @escaping(() -> Void)) {

        editIcon.setImage(icon, for: .normal)
        enterAmountLabel.text = enterAmountTitle
        amountTextfield.text = amount
        currencyLabel.text = currency
        buttonTapped = {
            iconTapped()
        }
    }

    public func getAmount() -> String? {
        amountTextfield.text
    }

    public func setAmount(_ amount: String) {
        amountTextfield.text = amount
    }

    func configureForPaymentView() {
        button.isHidden = true
        animate()
    }

    func animate() {
        editIcon.isHidden = true
        let animations: () -> () = {
            self.trailingConstraint.constant = 0
            self.leadingConstraint.constant = 0
            self.topConstraint.constant = -8
            self.bottomConstraint.constant = -20
            self.amountTopLabelConstraint.constant = 56
            self.amountBottomConstraint.constant = 60
            self.layoutIfNeeded()
            self.amountTextfield.becomeFirstResponder()
            self.backgroundView.backgroundColor = .kaoColor(.crimson)
            self.shadowView.dropShadow(shadowRadius: 0, shadowColor: .clear, shadowOffSet: CGSize(width: 0, height: 0), shadowOpacity: 0)
            self.shadowView.addCornerRadius(0)
        }

        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 0, options: [.curveLinear], animations: animations, completion: { isFinished in

            })
    }

    open func endAnimation(_ completed: @escaping (() -> Void)) {
        let animations: () -> () = {
            self.backgroundView.backgroundColor = .kaoColor(.crimson)
            self.shadowView.dropShadow(shadowRadius: 1, shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.2), shadowOffSet: CGSize(width: 0, height: 1), shadowOpacity: 0.3)
            self.amountTextfield.resignFirstResponder()
        }

        self.shadowView.dropShadow(shadowRadius: 0, shadowColor: .clear, shadowOffSet: CGSize(width: 0, height: 0), shadowOpacity: 0)
        self.backgroundView.backgroundColor = .kaoColor(.white)

        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 0, options: [.curveLinear], animations: animations, completion: { isFinished in
                completed()
            })
    }

    @IBAction func editIconDidTap() {
        buttonTapped?()
    }


    // MARK: - UITextfield delegate
    @IBAction private func textfieldDidChange(_ sender: UITextField) {
        //sender.text = (sender.text ?? "").autoAppendDecimal()
        //configureTextfieldUI(hideOthers: sender.text == "")

    }

    @IBAction func textChanged(_ sender: Any) {
        if let textField = sender as? UITextField {
            textChanged?(textField.text, { formattedText in
                textField.text = formattedText
            })
        }
    }
}

extension PaymentCalculatorHeaderView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { // allow backspace
            return true
        } else {
           return (textField.text ?? "").count < 18
        }
    }
}
