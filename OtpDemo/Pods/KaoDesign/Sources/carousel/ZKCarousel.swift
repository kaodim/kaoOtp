

import UIKit

@objc public protocol ZKCarouselDelegate: AnyObject {
    func carouselDidScroll()
    func carouselItemDidTap(index: Int)
}

public final class ZKCarousel: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - Properties

    private var timer: Timer?
    public var interval: Double = 10.0
    public var delegate: ZKCarouselDelegate?

    public var slides: [ZKCarouselSlide] = [] {
        didSet {
            updateUI()
        }
    }

    /// Calculates the index of the currently visible ZKCarouselCell
    public var currentlyVisibleIndex: Int? {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return collectionView.indexPathForItem(at: visiblePoint)?.item
    }

    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(tap:)))
        return tap
    }()

    public lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.hidesForSinglePage = true
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = UIColor.kaoColor(.crimson)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 16

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.register(ZKCarouselCell.self, forCellWithReuseIdentifier: "slideCell")
        cv.clipsToBounds = true
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    // MARK: - Default Methods

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupCarousel()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCarousel()
    }

    // MARK: - Internal Methods

    private func setupCarousel() {
        backgroundColor = .clear

        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.addGestureRecognizer(tapGesture)

        addSubview(pageControl)
        pageControl.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        pageControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 32).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 25).isActive = true
        bringSubviewToFront(pageControl)
    }

    @objc private func tapGestureHandler(tap: UITapGestureRecognizer?) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint) ?? IndexPath(item: 0, section: 0)
        let index = visibleIndexPath.item

        if index == (slides.count - 1) {
            let indexPathToShow = IndexPath(item: 0, section: 0)
            collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
        } else {
            let indexPathToShow = IndexPath(item: index + 1, section: 0)
            collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
        }
    }

    private func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.pageControl.numberOfPages = self.slides.count
            self.pageControl.size(forNumberOfPages: self.slides.count)
        }
    }

    // MARK: - Exposed Methods

    public func start() {
        stop()
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(tapGestureHandler(tap:)),
                                     userInfo: nil,
                                     repeats: true)
        timer?.fire()
    }

    public func stop() {
        timer?.invalidate()
    }

    public func disableTap() {
        /* This method is provided in case you want to remove the
         * default gesture and provide your own. The default gesture
         * changes the slides on tap.
         */
        collectionView.removeGestureRecognizer(tapGesture)
    }

    // MARK: - UICollectionViewDelegate & DataSource

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slideCell", for: indexPath) as! ZKCarouselCell
        cell.slide = slides[indexPath.item]
        cell.contentView.layer.cornerRadius = 6.0
        cell.contentView.layer.masksToBounds = true

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(slides.count == 1){
            return  CGSize(width: UIScreen.main.bounds.width - 32, height: collectionView.frame.height)
        }else{
           return CGSize(width: UIScreen.main.bounds.width / 1.2, height: collectionView.frame.height)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselItemDidTap(index: indexPath.row)
    }

    // MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let index = currentlyVisibleIndex {
            pageControl.currentPage = index
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.carouselDidScroll()
    }
}
