//
//  KaoIndicatorView.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 10/22/19.
//

import UIKit

public class KaoResetFilterView: UIView {

    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    private var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!

    public var buttonTapped: (() -> Void)?

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

        backgroundView.backgroundColor = .kaoColor(.crimson)
        backgroundView.addCornerRadius(20)
        shadowView.dropShadow(shadowRadius: 2, shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.2), shadowOffSet: CGSize(width: 0, height: 1), shadowOpacity: 0.3)
        titleLabel.font = .kaoFont(style: .medium, size: 15)
        titleLabel.textColor = .white
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoResetFilterView")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    public func configureButtonTitle(_ title: String, _ icon: UIImage?) {
        titleLabel.text = title
        self.icon.image = icon
    }

    @IBAction func buttonDidTap() {
        buttonTapped?()
    }
}

