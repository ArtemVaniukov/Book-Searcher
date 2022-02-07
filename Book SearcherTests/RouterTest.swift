//
//  RouterTest.swift
//  Book SearcherTests
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import XCTest
@testable import Book_Searcher


class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

class RouterTest: XCTestCase {
    
    var assembly = AssemblyBuilder()
    var navigationController = MockNavigationController()
    var router: RouterProtocol!

    override func setUpWithError() throws {
        router = Router(navigationController: navigationController, assemblyBuilder: assembly)
    }

    override func tearDownWithError() throws {
        router = nil
    }
    
    func testRouter() {
        router.showDetail(with: nil)
        let detailViewController = navigationController.presentedVC
        XCTAssertTrue(detailViewController is DetailViewController)
    }

}
