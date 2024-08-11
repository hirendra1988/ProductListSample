//
//  UIViewController+Extension.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 11/08/24.
//

import UIKit

extension UIViewController {

    func setCustomLeftBarButton(image: UIImage?, target: Any?, action: Selector?) {
        let customButton = UIButton(type: .custom)
        if let image = image {
            customButton.setImage(image, for: .normal)
            customButton.tintColor = .targetRed
        }
        customButton.addTarget(target, action: action ?? #selector(defaultAction), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: customButton)
        leftBarButtonItem.tintColor = UIColor.targetRed
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    @objc private func defaultAction() {
        self.navigationController?.popViewController(animated: true)
    }

    private struct AssociatedKeys {
        static var errorViewKey = "errorViewKey"
    }

    private var errorView: ErrorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.errorViewKey) as? ErrorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.errorViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func showErrorView(withMessage message: String, retryAction: Selector) {
        DispatchQueue.main.async {
            self.errorView = ErrorView()
            guard let errorView = self.errorView else {
                return
            }
            self.view.addSubview(errorView)
            errorView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                errorView.topAnchor.constraint(equalTo: self.view.topAnchor),
                errorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                errorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                errorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])

            self.errorView = errorView

            errorView.updateErrorMessage(message)
            errorView.setRetryAction(target: self, action: retryAction)
            errorView.isHidden = false
        }
    }

    func hideErrorView() {
        errorView?.removeFromSuperview()
        errorView = nil
    }
}
