//
//  KaoSlideUpPhoneTextFieldDialogView.swift
//  KaoDesign
//
//  Created by Ramkrishna on 27/05/2019.
//

import Foundation
import UIKit

public class KaoSlideUpPhoneTextFieldData {
    let headerTitle, buttonTitle: String
    var dismissTitle: String? = "Cancel"
    let phoneTextFielddata: KaoPhoneTextFieldData
    let delegates: KaoPhoneTextFieldDelegate
    let phoneTextViewStyle: KaoPhoneTextFieldStyle
    public var buttonTapped: ((_ text: String?) -> Void)?

    public init(_ headerTitle: String, _ buttonTitle: String, _ dismissTitle: String?,_ phoneTextViewStyle: KaoPhoneTextFieldStyle  = .vendor,
        _ phoneTextFielddata: KaoPhoneTextFieldData, _ delegates: KaoPhoneTextFieldDelegate) {
        self.headerTitle = headerTitle
        self.buttonTitle = buttonTitle
        self.dismissTitle = dismissTitle
        self.phoneTextFielddata = phoneTextFielddata
        self.delegates = delegates
        self.phoneTextViewStyle = phoneTextViewStyle
    }
}

public enum KaoPhoneTextFieldStyle {
    case customer
    case vendor
}

public class KaoSlideUpPhoneTextFieldDialogView: UIView {

    private var contentView: UIView!
    @IBOutlet weak var kaoPhoneTextField: KaoPhoneTextField!
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var updateButton: KaoButton!
    @IBOutlet weak var closeButton: KaoButton!
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var headerBorder: UIView!
    
    var inputString: String?
    var phoneNumber: String?

    var buttonTapped: ((_ text: String?) -> Void)?
    var cancelTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoSlideUpPhoneTextFieldDialogView")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }


    private func configureViews() {
        contentView = loadFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)

        bkgView.addCornerRadius(8)

        titleHeader.font = UIFont.kaoFont(style: .semibold, size: 16)
        titleHeader.textColor = UIColor.kaoColor(.black)

        closeButton.configure(type: .dismiss, size: 16)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.kaoPhoneTextField.textFieldBecomeFirstResponder()
            self.kaoPhoneTextField.selectTextRange()
        }
    }

    public func configureData(_ headerTitle: String?,
        _ buttonTitle: String,
        _ dismissTitle: String?,
        _ textFieldData: KaoPhoneTextFieldData,
        _ delegates: KaoPhoneTextFieldDelegate,
        _ textFieldStyle : KaoPhoneTextFieldStyle
        ) {
        self.titleHeader.text = headerTitle
        self.updateButton.setTitle(buttonTitle, for: .normal)
        self.closeButton.setTitle(dismissTitle, for: .normal)
        self.updateButton.isEnabled = false
        kaoPhoneTextField.configureStyle(kaoPhoneTextFieldStyle: textFieldStyle)
        kaoPhoneTextField.configure(textFieldData, delegates)
        configureTextFieldStyle(kaoPhoneTextFieldStyle: textFieldStyle)
        self.inputString = textFieldData.textFieldText
        self.phoneNumber = textFieldData.textFieldText
    }

    public func configureTextFieldStyle(kaoPhoneTextFieldStyle: KaoPhoneTextFieldStyle){
        if(kaoPhoneTextFieldStyle == .customer){
            headerBorder.isHidden = true
            titleHeader.textAlignment = .left
            titleHeader.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        }
    }

    public func configureError(_ error: String) {
        kaoPhoneTextField.configureError(error)
    }

    public func validation(isValid: Validation) {
        switch isValid {
        case .success: self.updateButton.isEnabled = true
        case .failure(let error):
            self.updateButton.isEnabled = false
            self.configureError(error)
        }
    }

    public func configureButton(_ isEnabled: Bool) {
        self.updateButton.isEnabled = isEnabled
    }

    @IBAction func cancelTapped(_ sender: Any) {
        self.cancelTapped?()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.buttonTapped?(inputString)
    }

}

extension KaoSlideUpPhoneTextFieldDialogView: KaoPhoneTextFieldDelegate {
    public func handleEvent(_ event: TextEvent) {
        if case .textDidChange(let text) = event {
            inputString = text
            if text?.isEmpty ?? true || text == phoneNumber {
                self.configureButton(false)
            }
        }
    }
}
