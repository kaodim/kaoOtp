//
//  KaoSlideUpPhoneTextFieldDialogViewController.swift
//  KaoDesign
//
//  Created by Ramkrishna on 26/12/2019.
//

import UIKit

protocol KaoSlideUpPhoneTextFieldProtocol {
    func validation(isValid: Validation)
}

public class KaoSlideUpPhoneTextFieldDialogViewController: KaoSlideUpDialogViewController {

    private var data: KaoSlideUpPhoneTextFieldData!
    public lazy var tableView
        : UITableView = {
            let view = UITableView.kaoDefault(delegate: self, dataSource: self)
            view.register(KaoGenericTableCell<KaoSlideUpPhoneTextFieldDialogView>.self, forCellReuseIdentifier: "KaoSlideUpPhoneTextFieldDialogView")
            view.separatorStyle = .none
            view.transform = CGAffineTransform(translationX: 0, y: 400)
            //view.isScrollEnabled = false
            return view
    }()

    init(data: KaoSlideUpPhoneTextFieldData) {
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

extension KaoSlideUpPhoneTextFieldDialogViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "KaoSlideUpPhoneTextFieldDialogView", for: indexPath) as? KaoGenericTableCell<KaoSlideUpPhoneTextFieldDialogView>,
                let view = cell.customView as? KaoSlideUpPhoneTextFieldDialogView else {
                    fatalError("nib not found")
            }
            view.cancelTapped = { [weak self] in
                self?.stopAnimation()
            }
            view.buttonTapped = { [weak self] text in
                self?.stopAnimation()
                self?.dismiss(animated: true, completion: {
                    self?.data.buttonTapped?(text)
                })
            }
            view.configureData(data.headerTitle, data.buttonTitle, data.dismissTitle, data.phoneTextFielddata, data.delegates, data.phoneTextViewStyle)

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
    public func presentKaoSlideUpPhoneTextFieldDialog(data: KaoSlideUpPhoneTextFieldData) -> KaoSlideUpPhoneTextFieldDialogViewController {
        let view = KaoSlideUpPhoneTextFieldDialogViewController(data: data)
        view.modalPresentationStyle = .overFullScreen
        present(view, animated: false, completion: nil)
        return view
    }
}

extension KaoSlideUpPhoneTextFieldDialogViewController: KaoSlideUpPhoneTextFieldProtocol {
    public func validation(isValid: Validation) {
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? KaoGenericTableCell<KaoSlideUpPhoneTextFieldDialogView>,
            let view = cell.customView as? KaoSlideUpPhoneTextFieldDialogView else {
                fatalError("nib not found")
        }
        view.validation(isValid: isValid)
    }
}
