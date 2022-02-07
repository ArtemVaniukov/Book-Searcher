//
//  DetailViewPresenter.swift
//  Book Searcher
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import Foundation


protocol DetailViewProtocol: AnyObject {
    func showBookDetails(_ book: Book?)
}

protocol DetailViewPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, networkService: NetworkService, router: RouterProtocol, book: Book?)
    func showBookDetails()
}

class DetailViewPresenter: DetailViewPresenterProtocol {
    
    private weak var view: DetailViewProtocol?
    
    private var router: RouterProtocol?
    private let networkService: NetworkService
    
    private var book: Book?
    
    
    required init(view: DetailViewProtocol, networkService: NetworkService, router: RouterProtocol, book: Book?) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.book = book
    }
    
    
    func showBookDetails() {
        view?.showBookDetails(book)
    }
    
}
