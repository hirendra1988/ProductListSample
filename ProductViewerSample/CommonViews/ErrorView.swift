//
//  ErrorView.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 11/08/24.
//

import UIKit

class ErrorView: UIView {

    // MARK: - UI Components
    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "error_icon")
        return imageView
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Something went wrong. Please try again."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .grayDarkest
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try Again", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup View
    private func setupView() {
        addSubview(errorImageView)
        addSubview(errorLabel)
        addSubview(retryButton)

        // Set constraints for errorLabel and retryButton
        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            errorImageView.widthAnchor.constraint(equalToConstant: 100),
            errorImageView.heightAnchor.constraint(equalToConstant: 100),

            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),

            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 10),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    // MARK: - Public Method to Handle Retry Action
    func setRetryAction(target: Any?, action: Selector) {
        retryButton.addTarget(target, action: action, for: .touchUpInside)
    }

    // MARK: - Public Method to Update Error Message
    func updateErrorMessage(_ message: String) {
        errorLabel.text = message
    }
}
