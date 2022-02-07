//
//  ViewController.swift
//  Book Searcher
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    var presenter: SearchPresenter!
    
    private var tableView: UITableView = {
        $0.register(BookCell.self, forCellReuseIdentifier: "BookCellID")
        $0.rowHeight = UITableView.automaticDimension
        return $0
    }(UITableView())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
    
}

extension SearchViewController: SearchViewProtocol {
    func success() {
        //
    }
    
    func error(with error: Error) {
        //
    }
}

extension SearchViewController {
    private func setupLayout() {
        
    }
}

