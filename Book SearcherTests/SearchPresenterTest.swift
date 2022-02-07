//
//  SearchPresenterTest.swift
//  Book SearcherTests
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import XCTest
@testable import Book_Searcher


class MockView: SearchViewProtocol {
    func success() {
        
    }
    
    func failure(with error: Error) {
        
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var books: [Book]!
    
    init() { }
    
    convenience init(books: [Book]?) {
        self.init()
        self.books = books
    }
    
    func fetchBooks(with query: String, completion: @escaping (Result<[Book]?, Error>) -> Void) {
        if let books = books {
            completion(.success(books))
        } else {
            let error = NSError(domain: "", code: -1, userInfo: [:])
            completion(.failure(error))
        }
    }
}

class SearchViewPresenterTest: XCTestCase {

    var view: MockView!
    var presenter: SearchViewPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    
    var books = [Book]()
    
    
    override func setUpWithError() throws {
        router = Router(navigationController: UINavigationController(), assemblyBuilder: AssemblyBuilder())
    }

    override func tearDownWithError() throws {
        view = nil
        presenter = nil
        networkService = nil
        router = nil
    }
    
    func testGetSuccessBook() {
        let links = ImageLinks(smallThumbnail: nil, thumbnail: nil)
        let volumeInfo = (VolumeInfo(title: "Foo", authors: ["Bar", "Baz"], description: nil, imageLinks: links))
        let book = Book(volumeInfo:volumeInfo)
        
        books.append(book)
        
        view = MockView()
        networkService = MockNetworkService(books: [book])
        presenter = SearchViewPresenter(view: view, networkService: networkService, router: router)
        
        var catchBooks: [Book]?
        
        networkService.fetchBooks(with: "") { result in
            switch result {
            case .success(let books):
                catchBooks = books
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
        
        XCTAssertNotEqual(catchBooks?.count, 0)
        XCTAssertEqual(catchBooks?.count, books.count)
    }
    
    func testGetFailureBook() {
        view = MockView()
        networkService = MockNetworkService(books: nil)
        presenter = SearchViewPresenter(view: view, networkService: networkService, router: router)
        
        var catchError: Error?
        
        networkService.fetchBooks(with: "") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                catchError = error
            }
        }
        XCTAssertNotNil(catchError)
    }

}

