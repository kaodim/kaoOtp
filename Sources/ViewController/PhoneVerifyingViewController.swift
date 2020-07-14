//
//  PhoneVerifyingViewController.swift
//  OtpFlow
//
//  Created by augustius cokroe on 19/07/2018.
//  Copyright © 2018 Auyotoc. All rights reserved.
//

import Foundation
import UIKit

open class PhoneVerifyingViewController: UIViewController {

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
        view.tapOtpViaPhoneCall = otpViaPhone
        view.tapPhoneNumberChange = changeNumber
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    private var pins: String = ""

    private var countdownTimer: Timer!
    private var countdown: Int = 0
    private var bottomConstraint: NSLayoutConstraint!

    public weak var phoneVerifyDataSource: PhoneVerifyDataSource?
    public weak var phoneVerifyDelegate: PhoneVerifyDelegate?
    
    // MARK: - View Cycle
    private func configureLayout() {
        bottomConstraint = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            bottomConstraint
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
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(pinEnterView)
        //contentView.addSubview(bottomView)
        configureLayout()
        reloadData()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)
        //beginEditing()
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        UIView.setAnimationsEnabled(true)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
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

    public func handleEditButtonVisiblity(isHidden: Bool){
        pinEnterView.btnEditPhoneNumber.isHidden = isHidden
    }

    public func configureErrorMessage(message: String){
        pinEnterView.configureErrorMessage(message: message)
        wrongOtpTyped()
    }

    public func reloadData() {
        if let headerParams = phoneVerifyDataSource?.headerViewText(in: self) {
            headerView.configure(headerViewParams: headerParams)
        }
        if let textfieldParams = phoneVerifyDataSource?.pinTextFieldAttribute(in: self),
            let resendButtonParams = phoneVerifyDataSource?.resendButtonAttribute(in: self),
            let phoneOtpParams = phoneVerifyDataSource?.otpViaPhoneAttributes(in: self),
            let editParams = phoneVerifyDataSource?.editNumberAttributes(in: self)
        {
            pinEnterView.configure(customButtonAttributes: resendButtonParams, textfieldAttribute: textfieldParams, buttonOtpViaPhoneAttr: phoneOtpParams, buttonEditPhoneNumberAttr: editParams)
        }

    }
    
    public func restartTimer() {
        if(countdownTimer != nil){
            countdownTimer.invalidate()
            countdownTimer = nil
            startResendTimer()
        }
    }

    public func startResendTimer() {
        if countdownTimer == nil {
            countdown = phoneVerifyDataSource?.resendCodeDelay(in: self) ?? 0
            countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateResendButton), userInfo: nil, repeats: true)
        }
    }

    public func wrongOtpTyped(){
        pinEnterView.wrongOtpTyped()
    }

    @objc private func updateResendButton() {
        pinEnterView.enableResetButton(enable: false, countDownStr: timeFormatted(countdown))
        if countdown != 0 {
            countdown -= 1
        } else {
            pinEnterView.enableResetButton()
            countdownTimer.invalidate()
            countdownTimer = nil
        }
    }


    private func animateLayout() {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%01d:%02d", minutes, seconds)
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

    private func otpViaPhone() {
        phoneVerifyDelegate?.otpViaPhoneTapped(in: self)
    }

    private func pinCompleted(_ completePin: String) {
        pins = completePin
        phoneVerifyDelegate?.verifyTapped(in: self, pins: pins)
    }

    private func pinReseted() {
        if pins != "" {
            pins = ""
        }
    }
}
