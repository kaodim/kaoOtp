//
//  PhoneVerifyingViewController.swift
//  OtpFlow
//
//  Created by augustius cokroe on 19/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

class PhoneVerifyingViewController: UIViewController {

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

    private lazy var pinEnterView: OtpPinEnterView = {
        let view = OtpPinEnterView()
        view.pinCompleted = pinCompleted
        view.pinReset = pinReseted
        view.tapResend = resendCode
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var bottomView: OtpBottomView = {
        let view = OtpBottomView()
        view.didTapNext = nextButtonTapped
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var pins: String = "" {
        didSet {
           configureBottomButton()
        }
    }

    public weak var phoneVerifyDataSource: PhoneVerifyDataSource?
    public weak var phoneVerifyDelegate: PhoneVerifyDelegate?
    
    // MARK: - View Cycle
    override func viewDidLayoutSubviews() {
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
            pinEnterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            pinEnterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            pinEnterView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
            ])
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow , object: nil)
        view.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(pinEnterView)
        contentView.addSubview(bottomView)
        reloadData()
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
        if let headerParams = phoneVerifyDataSource?.headerViewText(in: self) {
            headerView.configure(headerViewParams: headerParams)
        }
        if let textfieldParams = phoneVerifyDataSource?.pinTextFieldAttribute(in: self),
            let buttonParams = phoneVerifyDataSource?.resendButtonAttribute(in: self) {
            pinEnterView.configure(customButtonAttributes: buttonParams, textfieldAttribute: textfieldParams)
        }
        if let buttonParams = phoneVerifyDataSource?.bottomViewButtonText(in: self) {
            bottomView.configure(customButtonAttributes: buttonParams)
        }
        configureBottomButton()
    }

    private func configureBottomButton() {
        if !pins.isEmpty {
            bottomView.enableNextButton()
        } else {
            bottomView.enableNextButton(enable: false)
        }
    }

    // MARK: - Callback
    private func nextButtonTapped() {
        phoneVerifyDelegate?.verifyTapped(in: self, pins: pins)
    }

    private func resendCode() {
        phoneVerifyDelegate?.resendCodeTapped(in: self)
    }

    private func changeNumber() {
        phoneVerifyDelegate?.changeNumberTapped(in: self)
    }

    private func pinCompleted(_ completePin: String) {
        pins = completePin
    }

    private func pinReseted() {
        if pins != "" {
            pins = ""
        }
    }

}
