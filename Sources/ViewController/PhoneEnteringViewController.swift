//
//  PhoneEnteringViewController.swift
//  OtpFlow
//
//  Created by augustius cokroe on 17/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

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

    private lazy var textFieldView: OtpTextfieldView = {
        let view = OtpTextfieldView()
        view.didTapShowList = configureTableView
        view.didChangedText = phoneTextChanged
        view.textfieldDelegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.separatorColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red:0.9, green:0.91, blue:0.91, alpha:1).cgColor
        return view
    }()

    private lazy var bottomView: OtpBottomView = {
        let view = OtpBottomView()
        view.didTapNext = nextButtonTapped
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var countryList: [CountryPhone] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var selectedCountry: CountryPhone? {
        didSet {
            guard let safeCountry = selectedCountry else { return }
            textFieldView.configure(countryPhone: safeCountry)
        }
    }
    private var dropUpDownIcon: CustomDropUpDownImage?
    private var phoneNumber: String = ""

    public weak var phoneEnterDataSource: PhoneEnterDataSource?
    public weak var phoneEnterDelegate: PhoneEnterDelegate?

    // MARK: - View Cycle
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor)
            ])
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor)
            ])
        NSLayoutConstraint.activate([
            textFieldView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textFieldView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textFieldView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
            ])
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            tableView.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -1)
            ])
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -1),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow , object: nil)
        view.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(textFieldView)
        contentView.addSubview(tableView)
        contentView.addSubview(bottomView)
        reloadData()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFieldView.textfieldBecomeResponder()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }

    @objc private func keyboardWillShow(_ notif: Notification) {
        if let keyboardFrame: NSValue = notif.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let viewHeight = UIScreen.main.bounds.height - keyboardHeight
            NSLayoutConstraint.activate([
                contentView.heightAnchor.constraint(equalToConstant: viewHeight)
                ])
        }
    }

    func reloadData() {
        countryList = phoneEnterDataSource?.supportedCountryPhones(in: self) ?? []
        selectedCountry = phoneEnterDataSource?.selectedCountryPhone(in: self) ?? countryList.first
        dropUpDownIcon = phoneEnterDataSource?.dropDownUpImages(in: self)
        if let headerParams = phoneEnterDataSource?.headerViewText(in: self) {
            headerView.configure(headerViewParams: headerParams)
        }
        if let textfieldParams = phoneEnterDataSource?.textFieldAttribute(in: self) {
            textFieldView.configure(params: textfieldParams)
        }
        if let customButtonAttributes = phoneEnterDataSource?.bottomViewButtonText(in: self) {
            bottomView.configure(customButtonAttributes: customButtonAttributes)
        }
        configureTableView()
        configureBottomButton()
    }

    private func configureBottomButton() {
        if let _ = selectedCountry, !phoneNumber.isEmpty {
            bottomView.enableNextButton()
        } else {
            bottomView.enableNextButton(enable: false)
        }
    }

    // MARK: - Callback
    private func configureTableView() {
        if countryList.count > 1 {
            tableView.isHidden = !tableView.isHidden
            let icon = tableView.isHidden ? dropUpDownIcon?.dropDown : dropUpDownIcon?.dropUp
            textFieldView.configure(dropUpDownImage: icon)
        } else {
            tableView.isHidden = true
        }
    }

    private func nextButtonTapped() {
        guard let selectedCountry = selectedCountry else { return }
        phoneEnterDelegate?.nextButtonTapped(in: self, phoneNumber: phoneNumber, countryPhone: selectedCountry)
    }

    private func phoneTextChanged(_ text: String?) {
        phoneNumber = text ?? ""
        configureBottomButton()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PhoneEnteringViewController: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OtpCountrySelectionCell.init(style: .default, reuseIdentifier: "OtpCountrySelectionCell")
        cell.configure(countryPhone: countryList[indexPath.row])
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCountry = countryList[indexPath.row]
        configureTableView()
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
