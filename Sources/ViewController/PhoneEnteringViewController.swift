//
//  PhoneEnteringViewController.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit
import KaoDesign

open class PhoneEnteringViewController: UIViewController {
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerView: OtpHeaderView = {
        let view = OtpHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textFieldView: NumberField = {
        let view = NumberField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.didChangedText = { [weak self] text in
            self?.phoneTextChanged(text)
        }

        return view
    }()
    
    private lazy var bottomView: OtpBottomView = {
        let view = OtpBottomView()
        view.didTapNext = nextButtonTapped
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var countryList: [CountryPhone] = []
    private var selectedCountry: CountryPhone? {
        didSet {
//            reloadData()
        }
    }
    private var phoneNumber: String = ""
    private var bottomConstraint: NSLayoutConstraint!

    public weak var phoneEnterDataSource: PhoneEnterDataSource?
    public weak var phoneEnterDelegate: PhoneEnterDelegate?
    
    // MARK: - View Cycle
    private func configureLayout() {
        if #available(iOS 11.0, *){
            let safeAreaLayoutGuide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
        } else {
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: view.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
        }
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor)
            ])
        NSLayoutConstraint.activate([
            textFieldView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textFieldView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textFieldView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            textFieldView.heightAnchor.constraint(equalToConstant: 75)
            ])
        bottomConstraint = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomConstraint
            ])
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(textFieldView)
        contentView.addSubview(bottomView)
        configureLayout()
        reloadData()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)
        beginEditing()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        UIView.setAnimationsEnabled(true)
    }
    
    @objc private func keyboardWillShow(_ notif: Notification) {
        if let keyboardFrame: NSValue = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomConstraint.constant = -keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide(_ notif: Notification) {
        bottomConstraint.constant = 0
    }
    
    public func beginEditing(_ begin: Bool = true) {
        textFieldView.textfieldBecomeResponder()
    }
    
    public func reloadData() {
        selectedCountry = phoneEnterDataSource?.selectedCountryPhone(in: self) ?? countryList.first

    
        if let headerParams = phoneEnterDataSource?.headerViewText(in: self) {
            headerView.configure(headerViewParams: headerParams)
        }
        
        if let customButtonAttributes = phoneEnterDataSource?.bottomViewButtonText(in: self) {
            bottomView.configure(customButtonAttributes: customButtonAttributes)
        }
        
        if let customTextfieldAttr = phoneEnterDataSource?.textFieldAttribute(in: self) {
//            textFieldView.configureTextFieldLabel(with: customTextfieldAttr)
            textFieldView.configureView(data: customTextfieldAttr)
        }
        
        if let textFieldValue = phoneEnterDataSource?.textFieldValue(in: self){
//            textFieldView.setText(with: textFieldValue)
        }
    }
    
    open func configureBottomButton(enable: Bool) {
        bottomView.enableNextButton(enable: enable)
    }
    
    private func animateLayout() {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func nextButtonTapped() {
        guard let selectedCountry = selectedCountry else { return }
        phoneEnterDelegate?.nextButtonTapped(in: self, phoneNumber: phoneNumber, countryPhone: selectedCountry)
    }
    
    open func phoneTextChanged(_ text: String?) {
        phoneNumber = text ?? ""
    }
}

// MARK: - UITextFieldDelegate
extension PhoneEnteringViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
}



