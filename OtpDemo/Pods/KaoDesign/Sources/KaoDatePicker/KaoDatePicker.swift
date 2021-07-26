//
//  KaoDatePicker.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 12/9/19.
//

import UIKit

public class KaoDatePicker: UIView {

    @IBOutlet private weak var headerMenu: KaoHeaderMenu!
    @IBOutlet private weak var weekTitleView: UIView!
    @IBOutlet private weak var spacerHeight: NSLayoutConstraint!
    @IBOutlet private weak var indicatorViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var indicatorView: KaoIndicatorView!
    @IBOutlet private weak var collectionView: UICollectionView!

    var dateModel: AvailabilityCalendar? = nil {
        didSet {
            hideIndicatorView(!(dateModel?.meta.surchargable ?? false))
        }
    }

    public var selectedDate = [IndexPath]()
    public var localizedStrings: KaoCalendarLocalize!
    public var leftTap: (() -> Void)?
    public var rightTap: (() -> Void)?
    public var selectedDateValue: ((_ day: CalendarDay, _ indexPath: IndexPath) -> Void)?

    private var contentView: UIView!

    // MARK: - init methods
    init(_ localizedStrings: KaoCalendarLocalize) {
        super.init(frame: .zero)
        self.localizedStrings = localizedStrings
        setupViews()
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    // MARK: - Setup UI
    private func setupViews() {
        contentView = loadFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
        configureView()
        configureMenu()
        configureCollectionView()
    }

    private func loadFromNib() -> UIView {
        let nib = UIView.nibFromDesignIos("KaoDatePicker")
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }

    private func leftDidTap() {
        leftTap?()
    }

    private func rightDidTap() {
        rightTap?()
    }

    private func configureView() {
        hideIndicatorView(true)
        indicatorView.configureEdges(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        let screenWidth = UIScreen.main.bounds.width
        let weekView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: weekTitleView.frame.height))
        self.weekTitleView.addSubview(weekView)

        let weekWidth = screenWidth / 7

        let titles = [localizedStrings.localize(.mon),
            localizedStrings.localize(.tue),
            localizedStrings.localize(.wed),
            localizedStrings.localize(.thu),
            localizedStrings.localize(.fri),
            localizedStrings.localize(.sat),
            localizedStrings.localize(.sun)
        ]

        for i in 0..<7 {
            let week = UILabel(frame: CGRect(x: CGFloat(CGFloat(i) * weekWidth), y: 0, width: weekWidth, height: 44))
            week.textAlignment = .center
            weekView.addSubview(week)
            week.textColor = UIColor.kaoColor(.dustyGray2)
            week.font = UIFont.kaoFont(style: .semibold, size: 13)
            week.text = titles[i]
        }
    }

    private func configureMenu() {
        headerMenu.leftTap = leftDidTap
        headerMenu.rightTap = rightDidTap
        headerMenu.configureLeftButtonIcon("icon_mini_left")
        headerMenu.hideRightIcon(true)
    }

    private func configureCollectionView() {
        let nib = UIView.nibFromDesignIos("DatePickerCollectionReusableView")
        self.collectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeader")

        let nib1 = UIView.nibFromDesignIos(DatePickerCollectionViewCell.reuseIdentifier)
        self.collectionView.register(nib1, forCellWithReuseIdentifier: DatePickerCollectionViewCell.reuseIdentifier)

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 7
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width, height: 52)
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)

        collectionView.showsVerticalScrollIndicator = false
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset.bottom = 150
    }

    public func configureIndicatorEdge(_ edges: UIEdgeInsets) {
        indicatorView.configureEdges(edges)
    }

    public func configureIndicatorView(_ text: String) {
        hideIndicatorView(false)
        indicatorView.configureType(.orange)
        indicatorView.configureDescriptionWithLineSpacing(text, 3)
    }

    public func showLeftIcon(_ show: Bool) {
        indicatorView.showLeftIcon(show)
    }

    public func configureIndicatorImage(_ image: String) {
        indicatorView.configureIconFromLibrary(image)
    }

    public func configureIndicatorGif(_ image1: String, _ image2: String?) {
        indicatorView.configureIconGif(image1, image2)
    }

    public func hideIndicatorView(_ isHidden: Bool) {
        indicatorView.isHidden = isHidden 
        spacerHeight.constant = isHidden ? 0 : 23
    }

    public func configureMenuHeader(_ title: String) {
        headerMenu.configureTitle(title)
    }

    public func configureLeftIcon(_ image: String) {
        headerMenu.configureLeftButtonIcon(image)
    }

    public func adjustIndicatorHeight(_ height: CGFloat) {
        //indicatorViewHeight.constant = height
    }
}

extension KaoDatePicker: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let model = self.dateModel else { return 0 }
        guard let picker = model.calendarMonths else { return 0 }
        return picker.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = self.dateModel else { return 0 }
        guard let picker = model.calendarMonths else { return 0 }
        guard let items = picker[section].days else { return 0 }
        return items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DatePickerCollectionViewCell.reuseIdentifier, for: indexPath) as? DatePickerCollectionViewCell else { fatalError("DatePickerCollectionViewCell not found") }

        guard
            let model = self.dateModel,
            let picker = model.calendarMonths,
            let items = picker[indexPath.section].days else { fatalError("DatePickerCollectionViewCell data not found") }

        let day = items[indexPath.row]
        let date = day.value?.toDate()?.toString("dd")

        // Create blank space for calendar by checking optional
        if let available = day.available {
            cell.configureDate("\(date ?? "")")
            if day.showPrice ?? false {
                if let price = day.price {
                    let isPostiveSurcharge = price > 0
                    cell.configureSurcharge("\(day.readablePrice ?? "")", isPostiveSurcharge)
                }
            } else {
                cell.hideSurcharge(hide: true)
            }
        } else {
            cell.hideDate(true)
            cell.hideSurcharge(hide: true)
        }

        cell.isSelected(selectedDate.contains(indexPath))
        cell.configureUnavailability(day.available ?? false)

        return cell
    }
}

extension KaoDatePicker: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let model = self.dateModel,
            let picker = model.calendarMonths,
            let items = picker[indexPath.section].days else { return }

        let day = items[indexPath.row]
        if self.selectedDate.contains(indexPath) {
            if let index = self.selectedDate.firstIndex(of: indexPath) {
                self.selectedDate.remove(at: index)
            }
        } else {
            if day.available ?? false {
                selectedDate = [indexPath]
                selectedDateValue?(day, indexPath)
            }
        }
        collectionView.reloadData()
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
}

extension KaoDatePicker: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeader", for: indexPath) as! DatePickerCollectionReusableView
        guard let model = self.dateModel else { return header }
        guard let picker = model.calendarMonths else { return header }

        let calendar = picker[indexPath.section]
        let monthName = DateFormatter().monthSymbols[calendar.month - 1]
        header.monthLabel.text = "\(monthName) \(calendar.year)"
        return header
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height: 78)
    }
}
