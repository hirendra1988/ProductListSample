//
//  ProductDetailsViewControllerTests.swift
//  ProductViewerSampleTests
//
//  Created by Hirendra Sharma on 11/08/24.
//

import XCTest
@testable import ProductViewerSample

final class ProductDetailsViewControllerTests: XCTestCase {

    var viewModel: ProductDetailsViewModel!
    var viewController: ProductDetailsViewController!
    var parser = ParsingResponse()
    var expectation1: XCTestExpectation!
    var expectation2: XCTestExpectation!
    var expectation3: XCTestExpectation!
    var expectation4: XCTestExpectation!
    var expectation5: XCTestExpectation!
    var tableView: BaseTableView!
    typealias Snapshot = NSDiffableDataSourceSnapshot<ProductSection, ProductDetailsModel>

    override func setUpWithError() throws {
        viewModel = ProductDetailsViewModel(networkProtocol: MockProductDetails(), parser: parser, productId: "1")
        viewController = ProductDetailsViewController()
        viewController.viewModel = viewModel
        viewController.viewDidLoad()

        tableView = viewController.tableView
        let layout = UITableView.Style.plain
        tableView = BaseTableView(frame: .zero, style: layout)
        viewController.tableView = tableView
        tableView.register(ProductDetailsCell.self, forCellReuseIdentifier: "ProductDetailsCell")

        self.loadData()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        viewController = nil
    }

    func testInitWithCoder() {
        XCTAssertNotNil(ProductDetailsViewController(coder: NSCoder.empty()), "\(self.name): init(coder:) failed")
    }

    func loadData() {
        if let url = Bundle.main.url(forResource: "ProductDetails", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let response = parser.parse(data: data, type: ProductDetailsModel.self)
                switch response {
                case .success(let productModel):
                    self.viewController.viewModel.productDetailsModel = productModel
                    self.viewController.reloadData()
                case .failure(let error):
                    print(error)
                }
            } catch {
                print("error:\(error)")
            }
        }
    }

    // swiftlint:disable line_length
    func testProductDetailsData() {
        let model = viewController?.viewModel.productDetailsModel
        XCTAssertNotNil(model)
        let descText = "The 3-Series TCL Roku TV puts all your entertainment favorites in one place, allowing seamless access to thousands of streaming channels. The simple, personalized home screen allows seamless access to thousands of streaming channels, plus your cable box, Blu-ray player, gaming console, and other devices without flipping through inputs or complicated menus. Easy Voice Control lets you control your entertainment using just your voice. The super-simple remote—with about half the number of buttons on a traditional TV remote—puts you in control of your favorite entertainment. Cord cutters can access free, over-the-air HD content with the Advanced Digital TV Tuner or watch live TV from popular cable-replacement services like YouTube TV, Sling, Hulu and more."
        XCTAssertEqual(model?.description, descText)
        XCTAssertEqual(model?.title, "TCL 32\" Class 3-Series HD Smart Roku TV")
        XCTAssertEqual(model?.availability, "In stock")
        XCTAssertEqual(model?.fulfillment, "Online")
        XCTAssertEqual(model?.regularPrice?.currencySymbol?.rawValue, "$")
        XCTAssertEqual(model?.regularPrice?.amountInCents, 20999)
        XCTAssertEqual(model?.regularPrice?.displayString, "$209.99")

        XCTAssertEqual(model?.salePrice?.currencySymbol?.rawValue, "$")
        XCTAssertEqual(model?.salePrice?.amountInCents, 15999)
        XCTAssertEqual(model?.salePrice?.displayString, "$159.99")
    }
    // swiftlint:enable line_length

    func testCommonUI() {
        XCTAssertNotNil(viewController.reloadData())
        XCTAssertNotNil(viewController.hideIndicator())
        XCTAssertNotNil(viewController.showIndicator())
        XCTAssertNotNil(viewController.addErrorView(message: "Test"))
        XCTAssertNotNil(viewController.removeErrorView())
    }

    func testSnapshotApplication() {
        let dataSource = viewController.makeDataSource()

        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        if let model = self.viewController.viewModel.productDetailsModel {
            snapshot.appendItems([model])
        }
        dataSource.apply(snapshot, animatingDifferences: false)

        let numberOfRows = tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfRows, 1)

        guard let cell: ProductCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProductCell else {
            return
        }
        XCTAssertNotNil(cell)

        let subviews = cell.contentView.subviews

        guard let titleLabel: UILabel = subviews[1] as? UILabel else {
            return
        }
        let title = "TCL 32\" Class 3-Series HD Smart Roku TV"
        XCTAssertEqual(titleLabel.text, title)

        guard let priceLabel: UILabel = subviews[2] as? UILabel else {
            return
        }
        let price = "$209.99 \(ProductStrings.ProductList.regText) $209.99"
        XCTAssertEqual(priceLabel.text, price)

        guard let fullfillmentLabel: UILabel = subviews[3] as? UILabel else {
            return
        }
        XCTAssertEqual(fullfillmentLabel.text, "Online")
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

extension ProductDetailsViewControllerTests: ProductDetailsViewProtocol {
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

class MockProductDetails: NetworkManagerProtocol {
    func performRequest(urlStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = Bundle.main.url(forResource: "ProductDetails", withExtension: "json") {
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
