//
//  SearchPresenter.swift
//  Book Searcher
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import Foundation


protocol SearchViewProtocol: AnyObject {
    func success()
    func error(with error: Error)
}

protocol SearchViewPresenter: AnyObject {
    var books: [Book]? { get set }
    init(view: SearchViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func getBooks(with query: String)
    func didTapBook(_ book: Book?)
}

class SearchPresenter: SearchViewPresenter {
    
    weak var view: SearchViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol
    
    var books: [Book]?
    
    
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
                    self?.view?.error(with: error)
                }
            }
        }
    }
    
    func didTapBook(_ book: Book?) {
        router?.showDetail(with: book)
    }
}
