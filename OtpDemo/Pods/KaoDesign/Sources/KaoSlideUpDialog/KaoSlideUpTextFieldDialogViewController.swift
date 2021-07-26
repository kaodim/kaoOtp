//
//  KaoSlideUpTextFieldDialogViewController.swift
//  KaoDesign
//
//  Created by Ramkrishna on 26/12/2019.
//

import UIKit

public class KaoSlideUpTextFieldDialogData {
    let headerTitle, titleLabel, textFieldFloatTitle, textFieldTitle, buttonTitle: String
    var dismissTitle: String? = "Cancel"
    public var buttonTapped: ((_ text: String?) -> Void)?

    public init(_ headerTitle: String, _ titleLabel: String, _ textFieldFloatTitle: String, _ textFieldTitle: String, _ buttonTitle: String, _ dismissTitle: String?) {
        self.headerTitle = headerTitle
        self.titleLabel = titleLabel
        self.textFieldFloatTitle = textFieldFloatTitle
        self.buttonTitle = buttonTitle
        self.textFieldTitle = textFieldTitle
        self.dismissTitle = dismissTitle
    }
}

public class KaoSlideUpTextFieldDialogViewController: KaoSlideUpDialogViewController {

    private var data: KaoSlideUpTextFieldDialogData!
    public lazy var tableView: UITableView = {
        let view = UITableView.kaoDefault(delegate: self, dataSource: self)
        view.register(KaoGenericTableCell<KaoSlideUpDialogView>.self, forCellReuseIdentifier: "KaoSlideUpDialogView")
        view.separatorStyle = .none
        view.transform = CGAffineTransform(translationX: 0, y: 400)
        //view.isScrollEnabled = false
        return view
    }()

    init(data: KaoSlideUpTextFieldDialogData) {
        super.init(nibName: nil, bundle: nil)
        self.data = data
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("Deallocated..")
    }

    override public func viewDidLayoutSubviews() {
        heightConstraint.constant = CGFloat.greatestFiniteMagnitude
        tableView.invalidateIntrinsicContentSize()
        tableView.layoutIfNeeded()
        heightConstraint.constant = self.tableView.contentSize.height
    }

    override public func viewDidLoad() {
        super.presentView = tableView
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension KaoSlideUpTextFieldDialogViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "KaoSlideUpDialogView", for: indexPath) as? KaoGenericTableCell<KaoSlideUpDialogView>,
                let view = cell.customView as? KaoSlideUpDialogView else {
                    fatalError("nib not found")
            }
            view.cancelTapped = { [weak self] in
                self?.stopAnimation()
            }
            view.buttonTapped = data.buttonTapped
            view.configureData(data.headerTitle, data.titleLabel, data.textFieldFloatTitle, data.textFieldTitle, data.buttonTitle, data.dismissTitle)
            cell.clipsToBounds = false
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
}

// MARK: - Extension
extension UIViewController {
    public func presentKaoSlideUpDialog(data: KaoSlideUpTextFieldDialogData) {
        let view = KaoSlideUpTextFieldDialogViewController(data: data)
        view.modalPresentationStyle = .overFullScreen
        present(view, animated: false, completion: nil)
    }
}
