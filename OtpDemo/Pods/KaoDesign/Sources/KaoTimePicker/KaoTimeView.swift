//
//  KaoTimePicker.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 12/5/19.
//

import Foundation

class KaoTimeView: UIView {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var timeLabel: UILabel!

    private var contentView: UIView!

    static let reuseIdentifier = "KaoTimeView"

    private var dates: [TimeSlot] = []
    private var timeSelected: [String] = []
    private var chargeType: ChargeType = .none

    public var isSelected: ((_ selected: Bool) -> Void)?
    public var selectedTime: ((_ date: String, _ totalSurcharge: String, _ timeSurcharge: String, _ surchargeAmt: Int?, _ chargeType: ChargeType) -> Void)?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
        setupCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupCollectionView()
    }

    private func setupViews() {
        contentView = loadFromNib()
        contentView.frame = frame
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoTimeView")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UIView.nibFromDesignIos(TimePickerCollectionViewCell.reuseIdentifier), forCellWithReuseIdentifier: TimePickerCollectionViewCell.reuseIdentifier)
    }

    public func configureCollectionView(_ dates: [TimeSlot], hasSurcharge: Bool = false, _ chargeType: ChargeType) {
        self.dates = dates
        self.chargeType = chargeType
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 5
        let itemHeight: CGFloat = hasSurcharge ? 50 : 36

        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width, height: itemHeight)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        collectionView.collectionViewLayout = layout

        let maximumItem: CGFloat = 4.0
        let height: CGFloat = ceil(CGFloat(dates.count) / maximumItem)
        let collectionHeight: CGFloat = hasSurcharge ? 62 : 42
        collectionViewHeight.constant = height * collectionHeight

        collectionView.reloadData()
    }

    public func configureTime(_ time: String) {
        timeLabel.text = time.uppercased()
    }

    public func configureSelection(_ time: String) {
        timeSelected = [time]
    }
}

extension KaoTimeView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimePickerCollectionViewCell.reuseIdentifier, for: indexPath) as? TimePickerCollectionViewCell else { fatalError("TimePickerCollectionViewCell not found") }
        let date = dates[indexPath.row]
        cell.configureDate(date.value)

        if date.showPrice {
            let isPostiveSurcharge = date.price > 0
            cell.configureSurcharge(date.readablePrice, isPostiveSurcharge)
        } else {
            cell.disableSurcharge()
            cell.hideSurchargeView(true)
        }

        let hasSurcharge = date.surchargable || date.rebatable
        cell.configureSelected(hasSurcharge, timeSelected.contains(date.value))
        cell.configureAvailability(date.available)
        return cell
    }
}

extension KaoTimeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let date = dates[indexPath.row]

        if date.available {
            if timeSelected.contains(date.value) {
                isSelected?(false)
            } else {
                selectedTime?(date.value, date.localizedTotalPrice, date.readablePrice, date.price, chargeType)
                isSelected?(true)
                timeSelected = [date.value]
            }
        }
    }
}
