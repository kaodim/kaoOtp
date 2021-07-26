//
//  KaoSearchView.swift
//  KaodimIosDesign
//
//  Created by Ramkrishna Baddi on 29/07/19.
//  Copyright © 2019 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

public protocol SearchDelegate: class {
    func backButtonTap()
    func clearTextTap()
    func textfieldDidUpdate(_ text: String)
    func searchButtonTap(_ text: String)
    func textFieldDidBeginEditing()
    func textFieldDidEndEditing()
}

public extension SearchDelegate {
    func textFieldDidBeginEditing() { }
    func textFieldDidEndEditing() { }
}

public class KaoSearchView: UIView {

    // MARK: - Properties
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var searchBackIcon: UIButton!
    @IBOutlet private weak var searchTransactionTextfield: UITextField!
    @IBOutlet private weak var clearTextButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var cancelBtnWidth: NSLayoutConstraint!
    @IBOutlet private weak var searchBarTrailConstraint: NSLayoutConstraint!

    private var contentView: UIView!
    private weak var delegate: SearchDelegate?

    // MARK: - init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    // MARK: - Setup views
    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoSearchView")
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

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.kaoFont(style: .regular, size: 16)
        cancelButton.setTitleColor(UIColor.kaoColor(.vividBlue), for: .normal)

        cancelBtnWidth.constant = 0
        searchBarTrailConstraint.constant = 0

        searchTransactionTextfield.delegate = self
        searchTransactionTextfield.placeholder = "Search"
        searchTransactionTextfield.font = UIFont.kaoFont(style: .regular, size: 16)
        searchTransactionTextfield.textColor = UIColor.kaoColor(.black)
        searchTransactionTextfield.returnKeyType = .search
        searchView.addCornerRadius(6)

        configureButtonHideStatus()
    }

    public func setDelegate(_ delegate: SearchDelegate) {
        self.delegate = delegate
    }

    // MARK: - Class methods
    public func configureSearchImage(_ image: String = "icon_mini_search") {
        searchBackIcon.setImage(UIImage(named: image), for: .normal)
    }

    public func configureCloseImage(_ image: String = "icon_form_clear") {
        clearTextButton.setImage(UIImage(named: image), for: .normal)
    }

    public func configurePlaceholder(searchPlaceholder: String) {
        searchTransactionTextfield.placeholder = searchPlaceholder
    }

    public func setText(_ text: String) {
        searchTransactionTextfield.text = text
    }

    public func configureCancelButton(cancelText: String, color: UIColor = UIColor.kaoColor(.vividBlue)) {
        cancelButton.setTitle(cancelText, for: .normal)
        cancelButton.titleLabel?.textColor = color
    }

    private func configureButtonHideStatus() {
        clearTextButton.isHidden = searchTransactionTextfield.text?.isEmpty ?? true
        if searchTransactionTextfield.text?.isEmpty ?? false {
            cancelBtnWidth.constant = 0
            searchBarTrailConstraint.constant = 0
        } else {
            cancelBtnWidth.constant = 55
            searchBarTrailConstraint.constant = 16
        }
    }

    private func configureDidBeginEditing() {
        cancelBtnWidth.constant = 55
        searchBarTrailConstraint.constant = 16
    }

    @IBAction private func cancelButtonTapped() {
        searchTransactionTextfield.resignFirstResponder()
        searchTransactionTextfield.text = ""
        configureButtonHideStatus()
        self.delegate?.backButtonTap()
    }

    @IBAction private func clearTextTapped() {
        searchTransactionTextfield.text = ""
        clearTextButton.isHidden = searchTransactionTextfield.text?.isEmpty ?? true
        self.delegate?.clearTextTap()
    }

    @IBAction func textfieldDidChanged() {
        configureButtonHideStatus()
        self.delegate?.textfieldDidUpdate(searchTransactionTextfield.text ?? "")
    }

    public func focusTextField() {
        searchTransactionTextfield.becomeFirstResponder()
    }
}

// MARK: - TextField Delegate
extension KaoSearchView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTransactionTextfield.resignFirstResponder()
        self.delegate?.searchButtonTap(textField.text ?? "")
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTransactionTextfield.becomeFirstResponder()
        self.delegate?.textFieldDidBeginEditing()
        configureDidBeginEditing()
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidEndEditing()
    }
}
