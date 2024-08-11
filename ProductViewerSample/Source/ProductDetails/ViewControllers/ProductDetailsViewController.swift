//
//  ViewController.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 10/08/24.
//

import UIKit

class ProductDetailsViewController: BaseViewController {

    var tableView: BaseTableView = {
        let tableView = BaseTableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()

    // two typealias for more readable code, we will reuse this alias
    typealias DataSource = UITableViewDiffableDataSource<ProductSection, ProductDetailsModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ProductSection, ProductDetailsModel>
    private lazy var dataSource = makeDataSource()
    private let bottomButtonView = ContainerWithBottomButtonView(buttonTitle: ProductStrings.ProductDetail.addToCart)
    var viewModel: ProductDetailsViewModel!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
        registerTableViewCells()
        viewModel.getProductsDetails()
    }

    private func setupContainerWithBottomButtonConstraints() {
        bottomButtonView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bottomButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButtonView.heightAnchor.constraint(equalToConstant: 80),
            bottomButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupUI() {
        configureNavigationTitle(ProductStrings.ProductDetail.screenName)
        setCustomLeftBarButton(image: UIImage(named: "backArrow_ic"), target: self, action: #selector(backButtonTapped))

        view.addSubviewWithEdgeConstraints(tableView)
        tableView.dataSource = dataSource
        viewModel.delegate = self

        view.addSubview(bottomButtonView)
        setupContainerWithBottomButtonConstraints()
        bottomButtonView.addTarget(self, action: #selector(addToCartButtonTapped))
    }

    @objc func addToCartButtonTapped() {
        print("Button was tapped!")
    }

    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    func registerTableViewCells() {
        tableView.register(ProductDetailsCell.self, forCellReuseIdentifier: "ProductDetailsCell")
    }

    func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        if let model = self.viewModel.productDetailsModel {
            snapshot.appendItems([model])
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView,
                                    cellProvider: { (tableView, indexPath, _) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsCell",
                                                           for: indexPath) as? ProductDetailsCell else {
                return UITableViewCell()
            }
            if let product = self.viewModel.productDetailsModel {
                cell.configure(with: product)
            }
            return cell
        })
        return dataSource
    }

    @objc func retryButtonTapped() {
        hideErrorView()
        self.viewModel.getProductsDetails()
    }

}

extension ProductDetailsViewController: ProductDetailsViewProtocol {
    func showIndicator() {
        ActivityIndicator.show(on: self.view)
    }

    func hideIndicator() {
        ActivityIndicator.hide()
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.applyInitialSnapshot()
        }
    }

    func addErrorView(message: String) {
        showErrorView(withMessage: message, retryAction: #selector(retryButtonTapped))
        ActivityIndicator.hide()
    }

    func removeErrorView() {
        hideErrorView()
        ActivityIndicator.hide()
    }
}
