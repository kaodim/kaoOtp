//
//  KaoSlideUpHeaderView.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 10/22/19.
//

import UIKit

public protocol KaoSlideUpHeaderViewProtocol: class {
    func didTapOnLeftBtn()
    func didTapOnRightBtn()
}

public struct KaoSlideUpHeaderData {
    var title: String
    var leftBtnTitle: String? = nil
    var rightBtnTitle: String? = nil
    public var rightBtnImage: UIImage? = nil

    public init(title: String,
        leftBtnTitle: String? = nil,
        rightBtnTitle: String? = nil) {
        self.title = title
        self.leftBtnTitle = leftBtnTitle
        self.rightBtnTitle = rightBtnTitle
    }
}

public class KaoSlideUpHeaderView: UIView {

    private var contentView: UIView!
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var bkgView: UIView!

    public weak var delegate: KaoSlideUpHeaderViewProtocol?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        contentView = loadFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)

        titleHeader.font = UIFont.kaoFont(style: .semibold, size: 16)
        rightBtn.setTitleColor(UIColor.kaoColor(.vividBlue), for: .normal)
        leftBtn.setTitleColor(UIColor.kaoColor(.vividBlue), for: .normal)
        rightBtn.titleLabel?.font = .kaoFont(style: .medium, size: 15)
        leftBtn.titleLabel?.font = .kaoFont(style: .medium, size: 15)
        bkgView.addCornerRadius(8)
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoSlideUpHeaderView")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    public func configureType(_ title: String, leftBtnTitle: String? = nil, rightBtnTitle: String? = nil) {
        titleHeader.text = title

        if let leftBtnTitle = leftBtnTitle {
            leftBtn.setTitle(leftBtnTitle, for: .normal)
        } else {
            leftBtn.isHidden = true
        }

        if let rightBtnTitle = rightBtnTitle {
            rightBtn.setTitle(rightBtnTitle, for: .normal)
        } else {
            rightBtn.isHidden = true
        }
    }

    public func configureData(_ headerData: KaoSlideUpHeaderData) {
        configureType(headerData.title, leftBtnTitle: headerData.leftBtnTitle, rightBtnTitle: headerData.rightBtnTitle)

        if let rightBtnImage = headerData.rightBtnImage {
            self.rightBtn.setImage(rightBtnImage, for: .normal)
            self.rightBtn.setTitle("", for: .normal)
            rightBtn.isHidden = false
            rightBtn.tintColor = .black
        }
    }

    @IBAction func rightBtnTapped(_ sender: Any) {
        delegate?.didTapOnRightBtn()
    }

    @IBAction func leftBtnTapped(_ sender: Any) {
        delegate?.didTapOnLeftBtn()
    }

    public func isLeftBtnEnabled(_ isEnabled: Bool) {
        if isEnabled {
            self.leftBtn.setTitleColor(UIColor.kaoColor(.vividBlue), for: .normal)
        } else {
            self.leftBtn.setTitleColor(UIColor.kaoColor(.textDisable), for: .normal)
        }
        self.leftBtn.isEnabled = isEnabled
    }

    public func isRightBtnEnabled(_ isEnabled: Bool) {
        if isEnabled {
            self.rightBtn.setTitleColor(UIColor.kaoColor(.vividBlue), for: .normal)
        } else {
            self.rightBtn.setTitleColor(UIColor.kaoColor(.textDisable), for: .normal)
        }
        self.rightBtn.isEnabled = isEnabled
    }
}
