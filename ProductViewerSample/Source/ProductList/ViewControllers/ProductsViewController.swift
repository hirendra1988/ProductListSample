//
//  ViewController.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 10/08/24.
//

import UIKit

class ProductsViewController: BaseViewController {

    var tableView: BaseTableView = {
        let tableView = BaseTableView()
        return tableView
    }()

    // two typealias for more readable code, we will reuse this alias
    typealias DataSource = UITableViewDiffableDataSource<ProductSection, Product>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ProductSection, Product>
    private lazy var dataSource = makeDataSource()
    var viewModel = ProductsViewModel()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerTableViewCells()
        viewModel.getProductsList()
    }

    func setupUI() {
        configureNavigationTitle(ProductStrings.ProductList.screenName)
        view.addSubviewWithEdgeConstraints(tableView)

        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.prefetchDataSource = self
        viewModel.delegate = self
    }

    func registerTableViewCells() {
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
    }

    func applyInitialSnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.viewModel.productsModel?.products ?? [])
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView,
                                    cellProvider: { (tableView, indexPath, _) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell",
                                                           for: indexPath) as? ProductCell else {
                return UITableViewCell()
            }
            if let product = self.viewModel.productsModel?.products?[indexPath.row] {
                cell.configure(with: product)
            }
            return cell
        })
        return dataSource
    }

    @objc func retryButtonTapped() {
        hideErrorView()
        self.viewModel.getProductsList()
    }

}

// MARK: - UITableViewDelegate
extension ProductsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let product = self.viewModel.productsModel?.products?[indexPath.row] {
            let productDetailsVC = ProductDetailsViewController()
            productDetailsVC.viewModel = ProductDetailsViewModel(productId: "\(product.id ?? 0)")
            self.navigationController?.pushViewController(productDetailsVC, animated: true)
        }
    }
}

extension ProductsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap {
            self.viewModel.productsModel?.products?[$0.row].imageURL
        }
        viewModel.imagePrefetcher.prefetchImages(for: urls)
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap {
            self.viewModel.productsModel?.products?[$0.row].imageURL
        }
        viewModel.imagePrefetcher.cancelPrefetching(for: urls)
    }

}

extension ProductsViewController: ProductListViewProtocol {
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
