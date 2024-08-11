//
//  BaseTableView.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 10/08/24.
//

import UIKit

class BaseTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupCommonUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCommonUI()
    }

    private func setupCommonUI() {
        self.backgroundColor = UIColor.background
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 44
    }

}
