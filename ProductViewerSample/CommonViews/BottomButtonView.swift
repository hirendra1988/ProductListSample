//
//  BottomButtonView.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 11/08/24.
//

import UIKit

class BottomButtonView: UIView {

    private let button = UIButton(type: .system)

    init(title: String, padding: CGFloat = 16, height: CGFloat = 44) {
        super.init(frame: .zero)

        setupButton(title: title)
        setupConstraints(padding: padding, height: height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton(title: String) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = .targetRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .emphasis
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
    }

    private func setupConstraints(padding: CGFloat, height: CGFloat) {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }

    func addTarget(_ target: Any?, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
    }
}

class ContainerWithBottomButtonView: UIView {

    private let containerView = UIView()
    private let bottomButtonView: BottomButtonView

    init(buttonTitle: String) {
        let padding = UIDevice.current.userInterfaceIdiom == .pad ? 40.0 : 16.0
        self.bottomButtonView = BottomButtonView(title: buttonTitle, padding: padding, height: 44.0)
        super.init(frame: .zero)

        setupContainerView()
        setupBottomButtonView(padding: padding)
        applyCornerRadiusAndShadow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        containerView.backgroundColor = .white
    }

    private func setupBottomButtonView(padding: CGFloat) {
        containerView.addSubview(bottomButtonView)
        bottomButtonView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bottomButtonView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            bottomButtonView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            bottomButtonView.heightAnchor.constraint(equalToConstant: 44),
            bottomButtonView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15)
        ])
    }

    private func applyCornerRadiusAndShadow() {
        containerView.layer.cornerRadius = 12
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        // Add shadow to the containerView
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: -2) // Shadow on top
        containerView.layer.shadowRadius = 4

        // Create a shadow path for better performance
        containerView.layer.shadowPath = UIBezierPath(
            roundedRect: containerView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 10, height: 10)
        ).cgPath
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyCornerRadiusAndShadow()
    }

    func addTarget(_ target: Any?, action: Selector) {
        bottomButtonView.addTarget(target, action: action)
    }

    func getContainerView() -> UIView {
        return containerView
    }
}
