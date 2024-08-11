//
//  ProductCell.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 10/08/24.
//

import UIKit

enum LoadingState {
    case notLoading
    case loading
    case loaded(UIImage)
}

class ProductCell: UITableViewCell {

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .targetRed
        return activityIndicator
    }()

    private var loadingState: LoadingState = .notLoading {
        didSet {
            switch loadingState {
            case .notLoading:
                productImageView.image = UIImage(named: "placeholder_ic")
                activityIndicator.stopAnimating()
            case .loading:
                productImageView.image = nil
                productImageView.image = UIImage(named: "placeholder_ic")
                activityIndicator.startAnimating()
            case let .loaded(img):
                productImageView.image = img
                activityIndicator.stopAnimating()
            }
        }
    }

    private var imageHeight: CGFloat {
        let width = UIScreen.main.bounds.width
        let height = UIDevice.current.userInterfaceIdiom == .pad ? width * 0.20 : width * 0.35
        return height
    }

    private var padding: CGFloat {
        let padding = UIDevice.current.userInterfaceIdiom == .pad ? 40.0 : 16.0
        return padding
    }

    // MARK: - UI Components
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.extraThinGrey.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .small
        label.numberOfLines = 2
        label.textColor = UIColor.grayDarkest
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .small)
        return label
    }()

    private let fulfillmentLabel: UILabel = {
        let label = UILabel()
        label.font = .small
        label.textColor =  UIColor.textLightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .small)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .medium
        label.textColor = .black
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .medium)
        return label
    }()

    private let availabilityLabel: UILabel = {
        let label = UILabel()
        label.font = .small
        label.textColor = UIColor.textLightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .small)
        return label
    }()

    private let imagePrefetcher: ImagePrefetcher = {
        let imageFetcher = ImagePrefetcher()
        return imageFetcher
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupViews() {
        backgroundColor = .white
        self.selectionStyle = .none
        contentView.addSubview(productImageView)
        productImageView.addSubview(activityIndicator)
        contentView.addSubview(priceLabel)
        contentView.addSubview(fulfillmentLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(availabilityLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Product Image Constraints
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            productImageView.widthAnchor.constraint(equalToConstant: imageHeight),
            productImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            productImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),

            // Price Label Constraints
            priceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: padding),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),

            // fulfillmentLabel Label Constraints
            fulfillmentLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            fulfillmentLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            fulfillmentLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),

            // Description Label Constraints
            descriptionLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: fulfillmentLabel.bottomAnchor, constant: 8),

            // Availability Label Constraints
            availabilityLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            availabilityLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            availabilityLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            availabilityLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])

        // Activity Indicator Constraints
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: productImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 40),
            activityIndicator.heightAnchor.constraint(equalToConstant: 40)
        ])

    }

    override func layoutSubviews() {
        self.contentView.layoutIfNeeded()
    }

    // MARK: - Configure Cell
    func configure(with product: Product) {
        if let imgStr = product.imageURL {
            loadingState = .loading
            imagePrefetcher.loadImage(for: imgStr) { image in
                if let image = image {
                    self.loadingState = .loaded(image)
                } else {
                    self.loadingState = .notLoading
                }
            }
        }

        guard let price = product.regularPrice?.displayString,
              let fulfillment = product.fulfillment,
              let title = product.title,
              let availability = product.availability,
              let aisle = product.aisle else {
            return
        }
        priceLabel.text = "\(price) \(ProductStrings.ProductList.regText) \(price)"
        fulfillmentLabel.text = fulfillment.rawValue
        availabilityLabel.text = "\(availability.rawValue) \(ProductStrings.ProductList.inAisle) \(aisle)"
        descriptionLabel.text = title

        priceLabel.textColorChange(fullText: priceLabel.text ?? "",
                                   changeText: price,
                                   foregroundColor: UIColor.targetRed,
                                   font: .largeBold)

        availabilityLabel.textColorChange(fullText: availabilityLabel.text!,
                                          changeText: availability.rawValue,
                                          foregroundColor: UIColor.targetTextGreen,
                                          font: .small)
    }
}
