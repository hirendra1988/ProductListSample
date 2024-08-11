//
//  ProductsViewControllerTests.swift
//  ProductViewerSampleTests
//
//  Created by Hirendra Sharma on 10/08/24.
//

import XCTest
@testable import ProductViewerSample

final class ProductsViewControllerTests: XCTestCase {

    var viewModel: ProductsViewModel!
    var viewController: ProductsViewController!
    var parser = ParsingResponse()
    var expectation1: XCTestExpectation!
    var expectation2: XCTestExpectation!
    var expectation3: XCTestExpectation!
    var expectation4: XCTestExpectation!
    var expectation5: XCTestExpectation!
    var tableView: BaseTableView!
    typealias Snapshot = NSDiffableDataSourceSnapshot<ProductSection, Product>

    override func setUpWithError() throws {
        viewModel = ProductsViewModel(networkProtocol: MockNetworkClient(), parser: parser)
        viewController = ProductsViewController()
        viewController.viewModel = viewModel
        viewController.viewDidLoad()

        tableView = viewController.tableView
        let layout = UITableView.Style.plain
        tableView = BaseTableView(frame: .zero, style: layout)
        viewController.tableView = tableView
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")

        self.loadData()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        viewController = nil
    }

    func testInitWithCoder() {
        XCTAssertNotNil(ProductsViewController(coder: NSCoder.empty()), "\(self.name): init(coder:) failed")
    }

    func loadData() {
        if let url = Bundle.main.url(forResource: "ProductList", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let response = parser.parse(data: data, type: ProductsModel.self)
                switch response {
                case .success(let productModel):
                    self.viewController.viewModel.productsModel = productModel
                    self.viewController.reloadData()
                case .failure(let error):
                    print(error)
                }
            } catch {
                print("error:\(error)")
            }
        }
    }

    func testCommonUI() {
        XCTAssertNotNil(viewController.reloadData())
        XCTAssertNotNil(viewController.hideIndicator())
        XCTAssertNotNil(viewController.showIndicator())
        XCTAssertNotNil(viewController.addErrorView(message: "Test"))
        XCTAssertNotNil(viewController.removeErrorView())
    }

    func testProductListData() {
        XCTAssertNotNil(viewController?.viewModel.productsModel)
        XCTAssertNotNil(viewController?.viewModel.productsModel?.products)
        XCTAssertEqual(viewController?.viewModel.productsModel?.products?.count, 20)
    }

    func testSnapshotApplication() {
        let dataSource = viewController.makeDataSource()

        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.viewController.viewModel.productsModel?.products ?? [])
        dataSource.apply(snapshot, animatingDifferences: false)

        let numberOfRows = tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfRows, 20)

        guard let cell: ProductCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProductCell else {
            return
        }
        XCTAssertNotNil(cell)

        let subviews = cell.contentView.subviews

        guard let priceLabel: UILabel = subviews[1] as? UILabel else {
            return
        }
        let price = "$229.99 \(ProductStrings.ProductList.regText) $229.99"
        XCTAssertEqual(priceLabel.text, price)

        guard let fullfillmentLabel: UILabel = subviews[2] as? UILabel else {
            return
        }
        XCTAssertEqual(fullfillmentLabel.text, "Online")

        guard let titleLabel: UILabel = subviews[3] as? UILabel else {
            return
        }
        XCTAssertEqual(titleLabel.text, "VIZIO D-Series 40\" Class 1080p Full-Array LED HD Smart TV")

        guard let availabilityLabel: UILabel = subviews[4] as? UILabel else {
            return
        }
        let availability = "In stock \(ProductStrings.ProductList.inAisle) b2"
        XCTAssertEqual(availabilityLabel.text, availability)
    }

    func testReloadDataDelegate() {
        self.viewController.viewModel.delegate = self
        expectation1 = expectation(description: "Delegate method should be called")
        self.viewController.viewModel.delegate?.reloadData()

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Delegate method was not called: \(error)")
            }
        }
    }

    func testShowIndicatorDelegate() {
        self.viewController.viewModel.delegate = self
        expectation2 = expectation(description: "Delegate method should be called")
        self.viewController.viewModel.delegate?.showIndicator()

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Delegate method was not called: \(error)")
            }
        }
    }

    func testHideIndicatorDelegate() {
        self.viewController.viewModel.delegate = self
        expectation3 = expectation(description: "Delegate method should be called")
        self.viewController.viewModel.delegate?.hideIndicator()

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Delegate method was not called: \(error)")
            }
        }
    }

    func testAddErrorViewDelegate() {
        self.viewController.viewModel.delegate = self
        expectation4 = expectation(description: "Delegate method should be called")
        self.viewController.viewModel.delegate?.addErrorView(message: "Error Message")

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Delegate method was not called: \(error)")
            }
        }
    }

    func testRemoveErrorViewDelegate() {
        self.viewController.viewModel.delegate = self
        expectation5 = expectation(description: "Delegate method should be called")
        self.viewController.viewModel.delegate?.removeErrorView()

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Delegate method was not called: \(error)")
            }
        }
    }

}

extension ProductsViewControllerTests: ProductListViewProtocol {
    func reloadData() {
        expectation1.fulfill()
    }

    func showIndicator() {
        expectation2.fulfill()
    }

    func hideIndicator() {
        expectation3.fulfill()
    }

    func addErrorView(message: String) {
        expectation4.fulfill()
    }

    func removeErrorView() {
        expectation5.fulfill()
    }
}

final class MockNetworkClient: NetworkManagerProtocol {
    func performRequest(urlStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = Bundle.main.url(forResource: "ProductList", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                completion(.success(data))
            } catch {
                print("error:\(error)")
                completion(.failure(error))
            }
        }
    }
}
