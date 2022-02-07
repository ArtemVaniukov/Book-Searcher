//
//  AssemblyBuilder.swift
//  Book Searcher
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import UIKit


protocol AssemblyBuilderProtocol {
    func createSearchModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(book: Book, router: RouterProtocol) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createSearchModule(router: RouterProtocol) -> UIViewController {
        let networkService = NetworkService()
        let view = SearchViewController()
        let presenter = SearchPresenter(view: view, networkService: networkService, router: router)
        
        view.presenter = presenter
        
        return view
    }
    
    func createDetailModule(book: Book, router: RouterProtocol) -> UIViewController {
        // TODO: Create Detail Module
        return UIViewController()
    }
    
}
