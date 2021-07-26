//
//  CollapsibleTableViewHeader.swift
//  KaoDesign
//
//  Created by Ismail Sahak on 05/05/2020.
//

import UIKit
import Kingfisher

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ section: Int)
}

open class CollapsibleTableViewHeader: UIView, NibLoadableView {
    
    @IBOutlet private weak var arrowIcon: UIImageView!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var label: KaoLabel!
    private var contentView: UIView!
    
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("CollapsibleTableViewHeader")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    private func configureView() {
        contentView = loadFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)

        label.font = .kaoFont(style: .semibold, size: 15.0)
        label.textColor = UIColor.kaoColor(.black)
        arrowIcon.image = UIImage.imageFromDesignIos("ic_arrow_up")
    }
    
    public func configure(iconUrl: String?, labelText: String) {
        icon.cache(withURL: iconUrl ?? "", placeholder: nil) { [weak self] (image, _, _, _) in
            self?.icon.image = image
        }
        self.label.text = labelText
    }
    
    @IBAction func tapHeader(_ sender: Any) {
        delegate?.toggleSection(section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        arrowIcon.rotate(collapsed ? .pi : 0.0, collapsed ? 0.0 : .pi)
    }
    
}

extension UIView {
    func rotate(_ toValue: CGFloat, _ fromValue: CGFloat, duration: CFTimeInterval = 0.3) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
    
        self.layer.add(animation, forKey: nil)
    }
    
}
