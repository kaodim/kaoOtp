//
//  CountryOptionsView.swift
//  KaoOtpFlow
//
//  Created by Kelvin Tan on 9/25/18.
//

import Foundation

class CountryOptionsView: UIView {
    
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var countryImage: UIImageView!
    
    private var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    private func loadFromNib() -> UIView {
        let nib:UINib!
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "OtpCustomPod", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) {
            nib = UINib(nibName: "CountryOptionsView", bundle: bundle)
        } else {
            nib = UINib(nibName: "CountryOptionsView", bundle: Bundle.main)
        }
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
    }
    
    func configure(icon: UIImage?, label: String) {
        countryLabel.text = label
        countryImage.image = icon
    }
}
