//
//  ViewController.swift
//  Book Searcher
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    var presenter: SearchPresenter!
    
    private lazy var searchBar = UISearchBar(frame: .zero)
    private let bookCellID = "BookCellID"
    
    private lazy var tableView: UITableView = {
        $0.register(BookCell.self, forCellReuseIdentifier: bookCellID)
        return $0
    }(UITableView())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        // TODO: Move DataSource to a separate file
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        view.addAutolayoutSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
    
}

extension SearchViewController: SearchViewProtocol {
    func success() {
        tableView.reloadData()
    }
    
    func error(with error: Error) {
        let alertVC = UIAlertController(title: "WHOOPS!", message: error.localizedDescription, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.books?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: bookCellID, for: indexPath) as? BookCell else {
            return UITableViewCell()
        }
        
        if let book = presenter.books?[indexPath.row] {
            cell.setupCell(with: book)
        }
        return cell
    }
}

extension SearchViewController {
    private func setupSearchBar() {
        let navBarButton = UIBarButtonItem(customView: searchBar)
        navigationItem.leftBarButtonItem = navBarButton
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

