//
//  Router.swift
//  Book Searcher
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import UIKit


protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetail(with book: Book?)
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilder) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let searchViewController = assemblyBuilder?.createSearchModule(router: self) else { return }
            navigationController.viewControllers = [searchViewController]
        }
    }
    
    func showDetail(with book: Book?) {
        if let navigationController = navigationController {
            guard let detailViewController = assemblyBuilder?.createDetailModule(book: book, router: self) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
}
