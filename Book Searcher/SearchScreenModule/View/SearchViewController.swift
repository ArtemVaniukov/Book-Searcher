//
//  ViewController.swift
//  Book Searcher
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    var presenter: SearchViewPresenter!
    
    private lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 1500, height: 30))
    private let bookCellID = "BookCellID"
    
    private lazy var tableView: UITableView = {
        $0.register(BookCell.self, forCellReuseIdentifier: bookCellID)
        return $0
    }(UITableView())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupSearchBar()
        setupTableView()
        
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
    
    func failure(with error: Error) {
        // TODO: Move to a separate class
        let alertVC = UIAlertController(title: "WHOOPS!", message: error.localizedDescription, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

// TODO: Move DataSource to a separate file
extension SearchViewController: UITableViewDataSource {
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

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = presenter.books?[indexPath.row]
        presenter.didTapBook(book)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            presenter.getBooks(with: query)
        }
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController {
    private func setupSearchBar() {
        searchBar.placeholder = "Search a book"
        
        let navBarButton = UIBarButtonItem(customView: searchBar)
        navigationItem.leftBarButtonItem = navBarButton
        
        searchBar.delegate = self
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
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

