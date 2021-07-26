//
//  PaymentViewController.swift
//  KaoDesign
//
//  Created by Ramkrishna on 22/05/2020.
//

import UIKit

public protocol PaymentControllerFactory {

}

public protocol PaymentDelegates: class {
    func cancelTapped()
    func continueDidTap(_ amount: String, controller: UIViewController)
}

open class PaymentDependencyContainer {
    public var paymentData: PaymentData
    public var header: PaymentCalculatorHeaderData
    public weak var delegate: PaymentDelegates?
    public init(_ paymentData: PaymentData, header: PaymentCalculatorHeaderData, _ delegate: PaymentDelegates?) {
        self.paymentData = paymentData
        self.header = header
        self.delegate = delegate
    }
}

extension PaymentDependencyContainer: PaymentControllerFactory {

}

open class PaymentViewController: KaoBottomSheetController {

    // MARK: - Dependency Injection
    // Here we use protocol composition to create a Factory type that includes
    // all the factory protocols that this view controller needs.
    public typealias Factory = PaymentControllerFactory

    public let factory: Factory
    public var viewModel: PaymentViewModel!
    public weak var delegate: PaymentDelegates?
    var debouncer: Debouncer!
    var amount: Double = 0

    @IBOutlet private weak var contentView: UIStackView!
    @IBOutlet private weak var headerView: PaymentCalculatorHeaderView!

    @IBOutlet private weak var bottomButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomButtonView: UIView!

    @IBOutlet private weak var cancelButton: KaoButton!
    @IBOutlet private weak var continueButton: KaoButton!

    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var infoLabel: UILabel!


    public init(factory: Factory) {
        self.factory = factory
        let podBundle = Bundle(for: PaymentViewController.self)
        let bundleURL = podBundle.url(forResource: "KaoCustomPod", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)
        super.init(nibName: "PaymentViewController", bundle: bundle)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("Deallocated...")
    }

    open override func viewDidLoad() {
        setUpContentView()
        super.needListenToKeyboard = true
        super.shouldPush = true
        super.maxPresentHeight = UIScreen.main.bounds.height
        super.presentView = self.contentView
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let notchHeight: CGFloat = !phoneHasNotch ? 0 : 44 + 16
        let height: CGFloat = (UIScreen.main.bounds.height - 64 - notchHeight)
        super.presentViewHeight = height
        super.viewWillAppear(animated)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerView.configureForPaymentView()
        startViewAnimation()
    }

    // MARK: - Keyboard
    open override func keyboardWillShow(_ notification: Notification) {
        super.keyboardWillShow(notification)


        if var keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            if UIDevice.current.hasNotch {
                keyboardHeight -= 40
            }
            bottomButtonBottomConstraint.constant = -keyboardHeight
        }
    }

    open override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        bottomButtonBottomConstraint.constant = 0
    }

    // MARK: - Setup UI
    private func setupUI() {
        configureBottomButtonView()
        bottomButtonView.isHidden = true

        cancelButton.configure(type: .dismiss, size: .large)
        continueButton.configure(type: .primary, size: .large)

        let alertInfo = viewModel.paymentData.alertTypes.filter({ $0.alertTypes == .info }).first
        self.configureAlertInfo(alertInfo)
        debouncer = Debouncer.init(delay: 0.0, callback: validateAmount)

        continueButton.isEnabled = !viewModel.header.amount.isEmpty
    }

    public func setlocalizeStrings(_ cancelBtnTitle: String, _ continueBtnTitle: String) {
        cancelButton.setTitle(cancelBtnTitle, for: .normal)
        continueButton.setTitle(continueBtnTitle, for: .normal)
    }

    func setUpContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        view.addSubview(contentView)
        setUpHeader()

        if let amount = Double(viewModel.header.amount) {
            let isVaildAmount = self.viewModel.validateAmount(amount)
            configureButton(isVaildAmount)
        }
    }

    func setUpHeader() {
        if let headerData = viewModel.header {
            headerView.configureData(headerData.icon, headerData.enterAmountTitle, headerData.currency, headerData.amount, {
            })
            headerView.textChanged = { [weak self] (amount, completion) in
                if let formattedAmt = self?.formattedAmount(amount),
                    let decimalFormatedAmt = self?.decimalFormattedAmount(formattedAmt),
                    let amtInDoubles = Double(decimalFormatedAmt) {
                    self?.amount = amtInDoubles
                    completion(formattedAmt)
                    let isVaildAmount = self?.viewModel.validateAmount(amtInDoubles)
                    self?.configureButton(isVaildAmount ?? false)
                    self?.debouncer.call()
                }
            }
        }
    }

    open func formattedAmount(_ amount: String?) -> String? {
        amount
    }

    open func decimalFormattedAmount(_ amount: String?) -> String? {
        amount
    }

    private func configureButton(_ isValid: Bool) {
        continueButton.isEnabled = isValid
    }

    private func configureBottomButtonView() {
        bottomButtonView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bottomButtonView)
    }

    private func configureAlertInfo(_ alert: PaymentAlertData?) {
        if let alert = alert {
            infoLabel.text = alert.message
            icon.image = alert.icon
            infoLabel.textColor = alert.textColor
        }
    }

    private func validateAmount() {
        self.configureAlertInfo(self.viewModel.getAlertMessage(amount))
    }

    private func startViewAnimation() {

        let animations: (() -> Void) = {
            self.bottomButtonView.isHidden = false
            self.infoView.alpha = 1
            self.bottomButtonView.alpha = 1
        }

        bottomButtonView.alpha = 0
        infoView.alpha = 0
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 0, options: [.curveEaseIn], animations: animations, completion: { isFinished in

            })
    }

    // MARK: - Actions

    @IBAction func cancelTapped(_ sender: Any) {
        delegate?.cancelTapped()
    }

    @IBAction func continueTapped(_ sender: Any) {
        if let amount = headerView.getAmount() {
            delegate?.continueDidTap(amount, controller: self)
        }
    }
}
