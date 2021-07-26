//
//  KaoImagePreviewViewController.swift
//  KaoDesign
//
//  Created by augustius cokroe on 01/03/2019.
//

import Foundation
import Kingfisher
import UIKit

final class KaoImagePreviewViewController: UIViewController, UIScrollViewDelegate {

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.minimumZoomScale = 1.0
        view.maximumZoomScale = 10.0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()

    private lazy var photoImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var buttonClose: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.imageFromDesignIos("ic_close_light"), for: .normal)
        button.addTarget(self, action: #selector(actionClose), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .whiteLarge
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var url: String?
    private var image: UIImage?
    private var data: Data?

    init(imageURL: String? = nil, image: UIImage? = nil, data: Data? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.url = imageURL
        self.image = image
        self.data = data
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureLayout()
        setupImageView()
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(imageTapGestureHandler))
        doubleTap.numberOfTapsRequired = 2
        photoImageView.addGestureRecognizer(doubleTap)
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler))
        swipe.direction = .down
        photoImageView.addGestureRecognizer(swipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func configureLayout() {

        view.addSubview(buttonClose)
            NSLayoutConstraint.activate([
                buttonClose.topAnchor.constraint(equalTo: safeTopAnchor),
                buttonClose.trailingAnchor.constraint(equalTo: safeTrailingAnchor,constant: -16),
                buttonClose.widthAnchor.constraint(equalToConstant: 24),
                buttonClose.heightAnchor.constraint(equalToConstant: 24)
            ])

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: buttonClose.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeBottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeLeadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeTrailingAnchor)
            ])

        scrollView.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            photoImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            photoImageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
            ])

        scrollView.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 37),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 37)
            ])

    }

    @objc private func actionClose(){
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func imageTapGestureHandler() {
        if scrollView.zoomScale == 1.0 {
            scrollView.zoomScale = 2.0
        } else {
            scrollView.zoomScale = 1.0
        }
    }

    @objc private func swipeGestureHandler() {
        // Avoid dismissal on zooming mode
        guard (scrollView.zoomScale <= 1.0) else { return }
        dismiss(animated: true, completion: nil)
    }

    private func setupImageView() {
        if let image = image {
            loadingIndicator.stopAnimating()
            photoImageView.image = image
        } else if let url = url {
            
            photoImageView.cache(withURL: url, placeholder: UIImage(), completion: { [weak self] (_, _, _, imageUrl) in
                if(imageUrl == nil){
                    let url = URL(string: url)
                    self?.photoImageView.kf.indicatorType = .activity
                    self?.photoImageView.kf.setImage(with: url)
                }
                self?.loadingIndicator.stopAnimating()
            })
        } else if let data = data, let image = UIImage.init(data: data) {
            loadingIndicator.stopAnimating()
            photoImageView.image = image
        } else {
            loadingIndicator.stopAnimating()
        }
    }

    // MARK: - UIScrollviewDelegate
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // Avoid dismissal on zooming mode
        guard (scrollView.zoomScale <= 1.0) else { return }

        if scrollView.contentOffset.y >= 100.0 {
            // Dismiss on scroll-up
            dismiss(animated: true, completion: nil)
        } else if scrollView.contentOffset.y <= -100.0 {
            // Dismiss on scroll-down
            dismiss(animated: true, completion: nil)
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}

