//
//  BaseViewController.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 10/08/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCommonUI()
    }

    private func setupCommonUI() {
        self.view.backgroundColor = UIColor.background
    }

    func configureNavigationTitle(_ title: String) {
        self.title = title
    }

}
