//
//  StatusView.swift
//  KaodimIosDesign
//
//  Created by augustius cokroe on 23/07/2018.
//  Copyright © 2018 kaodim. All rights reserved.
//

import Foundation
import UIKit

public enum Status {
    case selected
    case unselected
}

public enum StatusPosition {
    case first
    case middle
    case last
}

public class StatusView: UIView {

    private var contentView: UIView!
    @IBOutlet weak var leftLineView: UIView!
    @IBOutlet weak var rightLineView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var customIconBkgView: UIView!
    @IBOutlet weak var customIcon: UIImageView!


    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("StatusView")
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

        self.leftLineView.backgroundColor = UIColor.kaoColor(.veryLightPink)
        self.rightLineView.backgroundColor = UIColor.kaoColor(.veryLightPink)

        self.statusLabel.font = UIFont.kaoFont(style: .regular, size: 12)
        customIcon.isHidden = true
    }

    func configure(status: KaoStatus,showLastLine: Bool) {
        statusLabel.text = status.text
        iconImageView.backgroundColor = .clear
        if status.isSelected == .selected {
            iconImageView.image = UIImage.imageFromDesignIos("icon_progressreached")
            self.statusLabel.textColor = UIColor.kaoColor(.malachite)
        } else {
            iconImageView.image = UIImage.imageFromDesignIos("icon_progressnext")
            self.statusLabel.textColor = UIColor.kaoColor(.dustyGray2)
        }

        switch status.position {
        case .first:
            self.leftLineView.backgroundColor = UIColor.clear
        case .middle:
            break
        case .last:
            self.rightLineView.backgroundColor = UIColor.clear

            if(showLastLine){
                self.customIconBkgView.backgroundColor = .clear
            } else {
                self.customIconBkgView.backgroundColor = .white
            }
        }

        if let icon = status.icon {
            configureCustomIcon(icon, status.borderColor)
        }

    }

    func configureCustomIcon(_ icon: UIImage, _ color: UIColor?) {
        iconImageView.isHidden = true
        customIcon.isHidden = false
        customIcon.image = icon
        customIconBkgView.makeRoundCorner()
        guard let color = color else {
            return
        }
        customIconBkgView.addBorderLine(width: 1, color: color)
    }

    func isEnableLeftLine(enable: Bool) {
        self.leftLineView.backgroundColor = enable ? UIColor.kaoColor(.malachite) : UIColor.kaoColor(.veryLightPink)
    }

    func isEnableRightLine(enable: Bool) {
        self.rightLineView.backgroundColor = enable ? UIColor.kaoColor(.malachite) : UIColor.kaoColor(.veryLightPink)
    }
}
