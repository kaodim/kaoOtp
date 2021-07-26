//
//  KaoSlideUpDialogViewController.swift
//  KaoDesign
//
//  Created by Ramkrishna on 24/12/2019.
//

import UIKit

open class KaoSlideUpDialogTableViewController: KaoTableViewController {

    lazy var transparentView: UIView = {
        var transparentView = UIView()
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        return transparentView
    }()

    public var bottomConstraint: NSLayoutConstraint!
    public var heightConstraint: NSLayoutConstraint!

    public var presentView: UIView!
    private var bottomInset: CGFloat = 0.0

    override open func viewDidLoad() {
        super.viewDidLoad()
        super.needListenToKeyboard = true
        configureLayout()
        // Do any additional setup after loading the view.
    }


    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
    }

    override open func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
            bottomInset = view.safeAreaInsets.bottom
        }
    }

    private func configureLayout() {
        self.view.backgroundColor = .clear
        transparentView.frame = self.view.frame
        view.addSubview(transparentView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stopAnimation))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0

        view.addSubview(presentView)

        bottomConstraint = presentView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: 0)
        heightConstraint = presentView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            presentView.leadingAnchor.constraint(equalTo: safeLeadingAnchor),
            presentView.trailingAnchor.constraint(equalTo: safeTrailingAnchor),
            heightConstraint,
            bottomConstraint
            ])
    }

    public func startAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.presentView.transform = CGAffineTransform.identity
        }, completion: nil)
    }

    @objc public func stopAnimation() {
        self.transparentView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.presentView.transform = CGAffineTransform(translationX: 0, y: 400)
        }, completion: { _ in
                self.dismissViewController()
            })
    }

    open override func keyboardWillShow(_ notification: Notification) {
        super.keyboardWillShow(notification)
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height - bottomInset
            bottomConstraint.constant = -keyboardHeight
            view.layoutIfNeeded()
        }
    }

    open override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        bottomConstraint.constant = 0
        view.layoutIfNeeded()
    }
}
