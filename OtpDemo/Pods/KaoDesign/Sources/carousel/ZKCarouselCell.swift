

import Foundation
import Kingfisher
import UIKit

public class ZKCarouselCell: UICollectionViewCell {
    // MARK: - Properties

    public var slide: ZKCarouselSlide? {
        didSet {
            guard let slide = slide else {
                return
            }
            parseData(forSlide: slide)
        }
    }

    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.backgroundColor = .clear
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Default Methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    private func setup() {
        backgroundColor = .clear
        clipsToBounds = true

        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.addCornerRadius(6)
        imageView.addBorderLine(width: 1, color: .kaoColor(.whiteLilac))

        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 32).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true

        contentView.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    private func parseData(forSlide slide: ZKCarouselSlide) {
        if let imageUrl = slide.imageUrl {
            let url = URL(string: imageUrl)
            imageView.kf.setImage(with: url)
        }
        if let image = slide.image {
            imageView.image = slide.image
        }
        if slide.title != nil {
            titleLabel.text = slide.title
            imageView.addBlackGradientLayer(frame: bounds)
        } else {
            titleLabel.isHidden = true
        }
        if slide.description != nil {
            descriptionLabel.text = slide.description
        } else {
            descriptionLabel.isHidden = true
        }
    }
}
