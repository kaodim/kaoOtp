//
//  KaoSlideUpTextFieldDialogViewController.swift
//  KaoDesign
//
//  Created by Ramkrishna on 26/12/2019.
//

import UIKit

/// Use KaoSlideUpTextViewDialogData and implemented callback to listen for taps
public class KaoSlideUpTextViewDialogData {
    public let headerTitle, titleLabel, textFieldFloatTitle, textFieldTitle, buttonTitle: String
    public var dismissTitle: String? = "Cancel"

    /// Minimum characters required to enable button
    public var minCharRequired: Int = 40

    /// Handle button tap
    public var buttonTapped: ((_ text: String?) -> Void)?
    public var cancelTapped: (() -> Void)?
    public var onTextChangeHandler: ((_ text: String?) -> Void)?

    /// The UITextView placeholder text
    public var placeHolder: String = ""


    public init(_ headerTitle: String, _ titleLabel: String, _ textFieldFloatTitle: String,
        _ textFieldTitle: String, _ buttonTitle: String) {
        self.headerTitle = headerTitle
        self.titleLabel = titleLabel
        self.textFieldFloatTitle = textFieldFloatTitle
        self.buttonTitle = buttonTitle
        self.textFieldTitle = textFieldTitle
    }
}

public class KaoSlideUpTextViewDialogViewController: KaoBaseViewController {

    private var data: KaoSlideUpTextViewDialogData!
    public lazy var tableView: UITableView = {
        let view = UITableView.kaoDefault(delegate: self, dataSource: self)
        view.register(KaoGenericTableCell<KaoSlideUpTextViewDialog>.self, forCellReuseIdentifier: "KaoSlideUpTextViewDialog")
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
    }()

    private var contentView = UIView()
    var headerHeightConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var text: String?
    private lazy var headerView: KaoSlideUpHeaderView = {
        let view = KaoSlideUpHeaderView()
        let title = data.headerTitle
        return view
    }()

    lazy var footerView: KaoBottomButtonView = {
        let view = KaoBottomButtonView()
        view.buttonDidTapped = { [weak self] in
            self?.doneTapped()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(data: KaoSlideUpTextViewDialogData) {
        super.init(nibName: nil, bundle: nil)
        self.data = data
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("Deallocated..")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        super.needListenToKeyboard = true
        setUpContentView()
        // Do any additional setup after loading the view.
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.navigationController?.navigationBar.isHidden = true
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    public override func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            // Adjust content inset on keypad shows
             let adjustHeight: CGFloat = phoneHasNotch ? 40 : 0
            var contentInset: UIEdgeInsets = tableView.contentInset
            contentInset.bottom = keyboardHeight + footerView.frame.size.height + adjustHeight
            tableView.contentInset = contentInset
            scrollToBottom()
            bottomConstraint.constant = -(keyboardHeight - adjustHeight)
        }
    }

    public override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        // Adjust content inset on keypad dismisses

        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInset
        bottomConstraint.constant = 0
    }

    func setupBackground() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }

    func setUpContentView() {
        self.view.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        let constraints: [NSLayoutConstraint] = [
            contentView.topAnchor.constraint(equalTo: safeTopAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: safeLeadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeTrailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeBottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        setUpHeader()
        setUpTableView()
        setUpFooterView()
    }

    func setUpHeader() {
        headerView.delegate = self
        headerView.configureType(data.headerTitle, leftBtnTitle: nil, rightBtnTitle: data.dismissTitle)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerView)
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: 50)
        headerHeightConstraint.isActive = true
        let constraints: [NSLayoutConstraint] = [
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)
        let constraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func setUpFooterView() {
        footerView.title = data.buttonTitle
        view.addSubview(footerView)
        bottomConstraint = footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        NSLayoutConstraint.activate([
            bottomConstraint,
            footerView.leadingAnchor.constraint(equalTo: safeLeadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: safeTrailingAnchor)
            ])
    }

    private func doneTapped() {
        self.data?.buttonTapped?(text)
        self.dismiss(animated: true, completion: nil)
    }

    private func textChanged(_ text: String?) {
        self.text = text
        footerView.enableButton = ((text?.count ?? 0) >= data.minCharRequired)
    }
}

extension KaoSlideUpTextViewDialogViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "KaoSlideUpTextViewDialog", for: indexPath) as? KaoGenericTableCell<KaoSlideUpTextViewDialog>,
                let view = cell.customView as? KaoSlideUpTextViewDialog else {
                    fatalError("nib not found")
            }

            view.configureData(data.headerTitle, data.titleLabel, data.textFieldFloatTitle, data.textFieldTitle, data.buttonTitle, data.dismissTitle, data.minCharRequired, data.placeHolder)
            cell.clipsToBounds = false
            if let contentView = cell.customView as? KaoSlideUpTextViewDialog {
                contentView.textDidChange = { [weak self] text in
                    self?.textChanged(text)
                }
            }
            return cell
        default:
            fatalError("section not found")
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension KaoSlideUpTextViewDialogViewController: KaoSlideUpHeaderViewProtocol {
    public func didTapOnRightBtn() {
        self.dismiss(animated: true, completion: nil)
        self.data?.cancelTapped?()
    }

    public func didTapOnLeftBtn() { }
}

// MARK: - Extension
extension UIViewController {
    public func presentKaoSlideUpTextViewDialog(data: KaoSlideUpTextViewDialogData) {
        let view = KaoSlideUpTextViewDialogViewController(data: data)
        view.modalPresentationStyle = .overCurrentContext
        present(view, animated: true, completion: {
            view.setupBackground()
        })
    }
}
