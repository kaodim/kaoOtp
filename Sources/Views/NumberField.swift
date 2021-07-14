//
//  NumberField.swift
//  Kaodim
//
//  Created by Kelvin Tan on 9/18/18.
//  Copyright © 2018 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation
import MaterialTextField

class NumberField: UIView {

    @IBOutlet weak private var textField: KaoBorderedTextField!
    @IBOutlet weak private var infoIcon: UIImageView!
    @IBOutlet weak private var infoLabel: UILabel!
    
    var didChangedText: ((_ text: String?) -> Void)?
    
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
            nib = UINib(nibName: "NumberField", bundle: bundle)
        } else {
            nib = UINib(nibName: "NumberField", bundle: Bundle.main)
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
        textField.changeHandler = didChangedText
    }
    
    func configureView(data: KaoTextFieldInputData){
        textField.configure(data, nil)
        infoLabel.text = data.titleLabel
        if let icon = data.rightIcon {
            infoIcon.image = UIImage.imageFromDesignIos(icon)
        }
    }

    func textfieldBecomeResponder() {
        textField.becomeFirstResponder()
    }
    
    func setText(with text: CustomTextfieldAttributes) {
        textField.text = text.label
    }
}
