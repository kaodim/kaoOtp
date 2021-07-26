//
//  KaoRibbon.swift
//  KaoDesign
//
//  Created by Augustius on 06/11/2019.
//

import Foundation

public class KaoRibbon: UIView {

    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var message: UILabel!
    private var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoRibbon")
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

        let degrees: Double = 41 //the value in degrees
        self.backView.transform = CGAffineTransform(rotationAngle: CGFloat(degrees * .pi/180))
    }

    public func configure(_ attrStr: NSAttributedString, backColor: UIColor = .kaoColor(.crimson)) {
        message.attributedText = attrStr
        backView.backgroundColor = backColor
    }
}
