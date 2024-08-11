//
//  ProductCell.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 10/08/24.
//

import UIKit

class ProductDetailsCell: UITableViewCell {

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
        let height = UIDevice.current.userInterfaceIdiom == .pad ? width * 0.50 : width * 0.85
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
        label.textColor =  .textLightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .small)
        return label
    }()

    private let titleLabel: UILabel = {
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
        label.font = .standard
        label.textColor = .textLightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .standard)
        return label
    }()

    private let imagePrefetcher: ImagePrefetcher = {
        let imageFetcher = ImagePrefetcher()
        return imageFetcher
    }()

    private let productTitle: UILabel = {
        let label = UILabel()
        label.font = .emphasis
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .emphasis)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .standard
        label.textColor = .textLightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .standard)
        return label
    }()

    // MARK: - UI Components
    private let emptyView: EmptyView = {
        let emptyView = EmptyView()
        emptyView.backgroundColor = .background
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        return emptyView
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(emptyView)
        contentView.addSubview(productTitle)
        contentView.addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Product Image Constraints
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            productImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            productImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),

            // Description Label Constraints
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 28),

            // priceLabel Label Constraints
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),

            // fulfillmentLabel Label Constraints
            fulfillmentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            fulfillmentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            fulfillmentLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),

            emptyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 20),
            emptyView.topAnchor.constraint(equalTo: fulfillmentLabel.bottomAnchor, constant: 12),

            productTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            productTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            productTitle.topAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: 20),

            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            descriptionLabel.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 20),
//            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -100)

        ])

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: productImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 40),
            activityIndicator.heightAnchor.constraint(equalToConstant: 40)
        ])

    }

    // MARK: - Configure Cell
    func configure(with product: ProductDetailsModel) {
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
              let description = product.description else {
            return
        }
        priceLabel.text = "\(price) \(ProductStrings.ProductList.regText) \(price)"
        fulfillmentLabel.text = fulfillment
        titleLabel.text = title
        productTitle.text = ProductStrings.ProductDetail.productDetails
        descriptionLabel.text = description

        priceLabel.textColorChange(fullText: priceLabel.text ?? "",
                                   changeText: price,
                                   foregroundColor: UIColor.targetRed,
                                   font: .largeBold)
    }
}
