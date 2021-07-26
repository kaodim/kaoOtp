//
//  KaoPopupViewControllers.swift
//  KaoDesign
//
//  Created by augustius cokroe on 01/03/2019.
//

import Foundation

public class KaoPopupViewControllers: KaoPresenterViewController {

    private lazy var popView: KaoPopupView = {
        let view = KaoPopupView()
        let settingButton = KaoPopupAction(title: buttonText, style: .primary)
        if let cancelText = self.cancelText {
            let cancelButton = KaoPopupAction(title: cancelText, style: .dismiss)
            view.configure(image, messageText: messageText, firstKaoButton: cancelButton, secondKaoButton: settingButton, imageHeight: imageHeight)
        } else {
            view.configure(image, messageText: messageText, secondKaoButton: settingButton, imageHeight: imageHeight)
        }

        view.firstButtonTapped = {
            self.dismissAnimation()
            self.firstButtonTapped?()
        }

        view.secondButtonTapped = {
            self.secondButtonTapped?()
        }

        view.linkTapped = { [weak self] url in
            self?.linkTapped?(url)
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var messageText: NSAttributedString!
    private var buttonText: String!
    private var cancelText: String?
    private var image: UIImage?
    private var firstKaoButton: KaoPopupAction?
    private var secondKaoButton: KaoPopupAction?
    private var imageHeight: CGFloat?

    public var linkTapped: ((_ url: URL) -> Void)?
    public var firstButtonTapped: (() -> Void)?
    public var secondButtonTapped: (() -> Void)?

    public convenience init(image: UIImage? = nil, imageHeight: CGFloat? = nil, _ message: String, buttonText: String, cancelText: String) {
        self.init(image: image, imageHeight: imageHeight, NSAttributedString(string: message), buttonText: buttonText, cancelText: cancelText)
    }

    public init(image: UIImage? = nil, imageHeight: CGFloat? = nil, _ message: NSAttributedString, buttonText: String, cancelText: String?) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
        self.messageText = message
        self.buttonText = buttonText
        self.cancelText = cancelText
        self.imageHeight = imageHeight
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.presentView = popView
        super.viewDidLoad()
    }

    public func configureOrientation(axis: NSLayoutConstraint.Axis) {
        popView.configureOrientation(axis: axis)
    }

    private func openSettingsScreen() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
