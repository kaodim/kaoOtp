//
//  KaoRecentSearchView.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 10/22/19.
//

import UIKit

public protocol KaoRecentSearchViewDelegate: class {
    func itemSelected(_ item: String)
    func clearTapped()
}

public class KaoRecentSearchView: UIView {

    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var backgroundViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundViewTopConstraint: NSLayoutConstraint!


    @IBOutlet private weak var clearBtn: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeight: NSLayoutConstraint!

    private var contentView: UIView!
    private let cellIdentifier = "RecentSearchCell"
    private let columnLayout = RecentSearchFlowLayout()
    var searchStrings = [String]()
    public weak var delegate: KaoRecentSearchViewDelegate?
    var itemDidSelect: ((_ searchText: String) -> Void)?

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

        if #available(iOS 10.0, *) {
            columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        } else {
            // Fallback on earlier versions
            columnLayout.estimatedItemSize = CGSize(width: 41, height: 41)
        }
        collectionView.collectionViewLayout = columnLayout
        collectionView.register(UIView.nibFromDesignIos(cellIdentifier), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = true
        titleLabel.font = .kaoFont(style: .bold, size: 18)
        clearBtn.titleLabel?.font = .kaoFont(style: .regular, size: 15)
        clearBtn.setTitleColor(.kaoColor(.dustyGray2), for: .normal)
    }

    public func configureData(_ items: [String], _ title: String, clearTitle: String, delegate: KaoRecentSearchViewDelegate) {
        self.titleLabel.text = title
        self.clearBtn.setTitle(clearTitle, for: .normal)
        self.searchStrings = items
        self.delegate = delegate
        reloadData()
    }

    public func clearData() {
        self.searchStrings = []
        self.reloadData()
    }

    public func reloadData() {
        self.collectionView.reloadData {
            let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.collectionViewHeight.constant = height
            self.layoutIfNeeded()
        }
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoRecentSearchView")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    @IBAction func clearBtnTapped(_ sender: Any) {
        self.delegate?.clearTapped()
    }

}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
extension KaoRecentSearchView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchStrings.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let view = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? RecentSearchCell else { fatalError("Cell not found.") }
        view.itemTapped = { [weak self] text in
            self?.delegate?.itemSelected(text)
        }
        view.configure(searchStrings[indexPath.row])
        return view
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
