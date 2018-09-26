//
//  CountrySelectionView.swift
//  KaoOtpFlow
//
//  Created by Kelvin Tan on 9/25/18.
//

import Foundation

protocol CountrySelectionDelegate {
    func selectedCountry(_ selectedCountry: CountryPhone)
}

class CountrySelectionView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.dropShadow(shadowRadius: 24, shadowColor: UIColor.black.withAlphaComponent(0.5), shadowOffSet: CGSize(width: 0, height: 2), shadowOpacity: 0.3)
        }
    }
    @IBOutlet weak var containerView: UIView!
    
    var delegate: CountrySelectionDelegate?
    var selectionDataSource: [CountryPhone] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var countriesCount: CGFloat {
        return CGFloat(selectionDataSource.count)
    }
    
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
            nib = UINib(nibName: "CountrySelectionView", bundle: bundle)
        } else {
            nib = UINib(nibName: "CountrySelectionView", bundle: Bundle.main)
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
        
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CountrySelectionView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = CountrySelectionTableViewCell.init(style: .default, reuseIdentifier: "CountrySelectionTableViewCell") as? CountrySelectionTableViewCell else {
            fatalError("Cell not found")
        }
        cell.configure(data: selectionDataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension CountrySelectionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.selectedCountry(selectionDataSource[indexPath.row])
    }
}
