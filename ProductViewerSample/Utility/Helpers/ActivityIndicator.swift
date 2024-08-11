//
//  ActivityIndicator.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 10/08/24.
//

import UIKit

class ActivityIndicator {

    private static var loaderView: UIView?

    static func show(on view: UIView) {
        let loaderView = UIView(frame: view.bounds)
        loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = loaderView.center
        activityIndicator.color = UIColor.targetRed
        activityIndicator.startAnimating()
        loaderView.addSubview(activityIndicator)
        view.addSubview(loaderView)
        self.loaderView = loaderView
    }

    static func hide() {
        DispatchQueue.main.async {
            self.loaderView?.removeFromSuperview()
            self.loaderView = nil
        }
    }
}
