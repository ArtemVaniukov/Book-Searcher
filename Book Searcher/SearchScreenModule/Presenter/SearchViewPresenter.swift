//
//  SearchViewPresenter.swift
//  Book Searcher
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import UIKit


protocol SearchViewProtocol: AnyObject {
    func success()
    func failure(with error: Error)
}

protocol SearchViewPresenterProtocol: AnyObject {
    var books: [Book]? { get }
    init(view: SearchViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func getBooks(with query: String)
    func didTapBook(_ book: Book?)
}

class SearchViewPresenter: SearchViewPresenterProtocol {
    
    weak private var view: SearchViewProtocol?
    private var router: RouterProtocol?
    private let networkService: NetworkServiceProtocol
    
    private(set) var books: [Book]?
    
    
    required init(view: SearchViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    
    func getBooks(with query: String) {
        networkService.fetchBooks(with: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    self?.books = books
                    self?.view?.success()
                case .failure(let error):
                    self?.view?.failure(with: error)
                }
            }
        }
    }
    
    func didTapBook(_ book: Book?) {
        router?.showDetail(with: book)
    }
    
}
