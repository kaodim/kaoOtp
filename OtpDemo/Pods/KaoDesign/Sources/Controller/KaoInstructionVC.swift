//
//  KaoInstructuionVC.swift
//  Kaodim
//


import Foundation
import KaoDesign
import UIKit

class KaoInstructuionVC: KaoBaseViewController {

    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var transparentView: UIView!

    @IBOutlet private weak var containerView: UIView!

    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var labelMessage: UILabel!
    
    @IBOutlet private weak var btnOk: UIButton!
    @IBOutlet private weak var distanceConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var pulseViewCenterPosition: NSLayoutConstraint!
    @IBOutlet private weak var transparentViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var transparentViewWidth: NSLayoutConstraint!
    
    @IBOutlet private weak var imageViewPulseHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewPulse: UIImageView!
    private var positionRect: CGRect!
    private var kaoInstruction: KaoInstruction!
    private var heightFactor: CGFloat = 0.0


    var didTappedOkButton: (() -> Void)?

    init(positionRect: CGRect,kaoInstruction: KaoInstruction,heightFactor: CGFloat,didTappedOkButton: (() -> Void)?) {
        self.positionRect = positionRect
        self.kaoInstruction = kaoInstruction
        self.didTappedOkButton = didTappedOkButton
        self.heightFactor = heightFactor
        super.init(nibName: "KaoInstructuionVC", bundle: UIView.nibBundleDesignIos())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        print("Deallocated")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    private func setView(){
        view.backgroundColor = UIColor.black.withAlphaComponent(0)

        let newText = NSMutableAttributedString(string: " NEW ", attributes: [
            NSAttributedString.Key.backgroundColor: UIColor.kaoColor(.kaodimRed10),
            NSAttributedString.Key.foregroundColor: UIColor.kaoColor(.crimson),
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.semibold),
            NSAttributedString.Key.baselineOffset: 2
        ])

        let message = NSMutableAttributedString(string: kaoInstruction.title + "  ", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold),
        ])

        let combinedText = NSMutableAttributedString()
        combinedText.append(message)
        combinedText.append(newText)

        labelTitle.attributedText = combinedText

        labelMessage.text = kaoInstruction.message
        btnOk.setTitle(kaoInstruction.nextTitle.firstCharacterUpperCase() , for: .normal)

        containerView.addCornerRadius(8)
        btnOk.addCornerRadius()

        imageViewPulse.image = UIImage.imageFromDesignIos("ic_tuto")

        transparentViewHeight.constant = positionRect.height
        transparentViewWidth.constant = positionRect.width

        var distance = positionRect.size.height +  positionRect.origin.y
        distance = distance + heightFactor
        distanceConstraint.constant = distance

        pulseViewCenterPosition.constant = positionRect.origin.x
    }

    @IBAction func actionOktapped(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.didTappedOkButton?()
        })
    }
}

public extension UIViewController {
    func presentKaoInstructuionVC(positionRect: CGRect,kaoInstruction: KaoInstruction,heightFactor: CGFloat = 0.0,didTappedOkButton: (() -> Void)?) {
        let moreInstructionVC = KaoInstructuionVC(positionRect: positionRect, kaoInstruction: kaoInstruction,heightFactor: heightFactor,didTappedOkButton: didTappedOkButton)
        moreInstructionVC.modalPresentationStyle = .overCurrentContext
        self.present(moreInstructionVC, animated: false, completion: nil)
    }
}
