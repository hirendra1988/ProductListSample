//
//  EmptyView.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 10/08/24.
//

import UIKit

class EmptyView: UIView {

    // MARK: - Properties
    private let topSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .thinBorderGray
        return view
    }()

    private let bottomSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .thinBorderGray
        return view
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        // Add separators to the container view
        addSubview(topSeparator)
        addSubview(bottomSeparator)

        // Disable autoresizing mask translation into constraints
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints
        NSLayoutConstraint.activate([
            // Top separator constraints
            topSeparator.topAnchor.constraint(equalTo: topAnchor),
            topSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: 1), // Height of the top separator

            // Bottom separator constraints
            bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1) // Height of the bottom separator
        ])
    }
}
