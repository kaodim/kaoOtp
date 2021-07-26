//
//  KaoHeaderMenu.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 12/5/19.
//

import Foundation

open class KaoHeaderMenu: UIView {
    
    private var contentView: UIView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var leftButtonWidth: NSLayoutConstraint!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private weak var rightButtonWidth: NSLayoutConstraint!
    @IBOutlet private weak var rightButtonHeight: NSLayoutConstraint!
    @IBOutlet private weak var divider: UIView!
    
    public var leftTap: (() -> Void)?
    public var rightTap: (() -> Void)?
    
    // MARK: - init methods
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        contentView = loadFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
    }
    
    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoHeaderMenu")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }
    
    public func configureLeftButtonTitle(_ title: String, color: UIColor) {
        leftButton.setTitle(title, for: .normal)
        leftButton.setTitleColor(color, for: .normal)
        leftButton.sizeToFit()
    }
    
    public func configureLeftButtonIcon(_ image: String, width: CGFloat = 24, color: UIColor = UIColor.black) {
        let leftImage = UIImage.imageFromDesignIos(image)
        leftButton.setImage(leftImage, for: .normal)
        leftButtonWidth.constant = width
        leftButton.tintColor = color
    }
    
    public func hideLeftIcon(_ shouldHide: Bool) {
        leftButton.isHidden = shouldHide
    }
    
    public func configureRightButtonTitle(_ title: String, color: UIColor) {
        rightButton.setTitle(title, for: .normal)
        rightButton.setTitleColor(color, for: .normal)
        rightButton.sizeToFit()
    }
    
    public func configureRightButtonIcon(_ image: String, width: CGFloat = 24, color: UIColor = UIColor.black) {
        let rightImage = UIImage.imageFromDesignIos(image)
        rightButton.setImage(rightImage, for: .normal)
        rightButtonWidth.constant = width
        rightButton.tintColor = color
    }
    
    public func hideRightIcon(_ shouldHide: Bool) {
        rightButton.isHidden = shouldHide
    }
    
    public func configureDividerColor(_ color: UIColor) {
        divider.backgroundColor = color
    }
    
    public func configureTitle(_ text: String, color: UIColor = UIColor.kaoColor(.black)) {
        titleLabel.text = text
        titleLabel.textColor = color
    }
    
    @IBAction func leftDidTapped() {
        leftTap?()
    }
    
    @IBAction func rightDidTapped() {
        rightTap?()
    }
}
