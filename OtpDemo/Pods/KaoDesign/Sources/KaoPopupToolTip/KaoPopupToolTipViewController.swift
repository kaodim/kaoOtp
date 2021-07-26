//
//  KaoPopupToolTipViewController.swift
//  Kaodim
//
//  Created by Kelvin Tan on 1/6/20.
//  Copyright © 2020 Kaodim Sdn Bhd. All rights reserved.
//

import UIKit

public struct ToolTipData {
    public let description: NSAttributedString
    public let deeplinkUrl: String
    public let weblinkUrl: String
    public var backgroundColor: UIColor = .white
    public var alignment: NSTextAlignment = .natural
    public var edgeInset: UIEdgeInsets?

    public init(description: NSAttributedString, deeplinkUrl: String, weblinkUrl: String) {
        self.description = description
        self.deeplinkUrl = deeplinkUrl
        self.weblinkUrl = weblinkUrl
    }
}

class KaoPopupToolTipViewController: UIViewController {

    @IBOutlet private weak var popUpLabel: UILabel!

    @IBOutlet private weak var tipLeading: NSLayoutConstraint!
    @IBOutlet private weak var tipTrailing: NSLayoutConstraint!
    @IBOutlet private weak var tipTop: NSLayoutConstraint!
    @IBOutlet private weak var tipBottom: NSLayoutConstraint!

    private var position: CGPoint!
    private var toolTipData: ToolTipData!

    public var popUpTap: ((_ ToolTipData: ToolTipData) -> Void)?
    public var dismiss: (() -> Void)?

    init(_ toolTipData: ToolTipData) {
        self.toolTipData = toolTipData
        let podBundle = Bundle(for: KaoPopupToolTipViewController.self)
        let bundleURL = podBundle.url(forResource: "KaoCustomPod", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)
        super.init(nibName: "KaoPopupToolTipViewController", bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        print("Deallocated")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.popoverPresentationController?.backgroundColor = toolTipData.backgroundColor
        self.view.backgroundColor = toolTipData.backgroundColor
    }

    private func configureView() {
        popUpLabel.textAlignment = toolTipData.alignment
        popUpLabel.addLineSpacing(20, lineHeightMultiple: 0)
        popUpLabel.attributedText = toolTipData.description

        if let edgeInset = toolTipData.edgeInset {
            tipTop.constant = edgeInset.top
            tipBottom.constant = edgeInset.bottom
            tipLeading.constant = edgeInset.left
            tipTrailing.constant = edgeInset.right
        }
    }

    func getViewHeight() -> CGFloat {
        guard let labelHeight = self.popUpLabel.text?.height(withConstrainedWidth: (UIScreen.main.bounds.width - 40), font: UIFont.systemFont(ofSize: 15, weight: .regular)) else { return 0 }
        return labelHeight
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissView()
    }

    @IBAction func popUpDidTapped() {
        dismissView {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.popUpTap?(self.toolTipData)
            }
        }
    }

    private func dismissView(_ completion: (() -> Void)? = nil) {
        self.dismiss(animated: false, completion: nil)
        completion?()
    }
}

extension KaoPopupToolTipViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
}

extension UIViewController {
    public func presentPopupToolTipVC(_ sourceView: UIView, _ toolTipData: ToolTipData, popUpTap: @escaping ((_ toolTipData: ToolTipData) -> Void), sourceRect: CGRect, _ screenWidth: CGFloat) {
        let view = KaoPopupToolTipViewController(toolTipData)

        view.view.addCornerRadius()
        view.popUpTap = popUpTap

        let nav = UINavigationController(rootViewController: view)

        nav.preferredContentSize = CGSize(width: UIScreen.main.bounds.width * screenWidth, height: view.getViewHeight() + 10)
        nav.modalPresentationStyle = .popover
        nav.popoverPresentationController?.delegate = view
        nav.popoverPresentationController?.permittedArrowDirections = .down
        nav.popoverPresentationController?.sourceView = sourceView
        nav.popoverPresentationController?.sourceRect = sourceRect
        self.present(nav, animated: false, completion: {
            view.view.superview?.layer.cornerRadius = 4.0
        })
    }
}
