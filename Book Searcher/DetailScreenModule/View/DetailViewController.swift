//
//  DetailViewController.swift
//  Book Searcher
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import UIKit


class DetailViewController: UIViewController {
    
    var presenter: DetailViewPresenterProtocol!
    
    private var thumbnail: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private var scrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        return $0
    }(UIScrollView())
    
    private var scrollViewContent: UIView = {
        return $0
    }(UIView())
    
    private var bookLabel: UILabel = {
        $0.lineBreakMode = .byWordWrapping
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .preferredFont(forTextStyle: .headline).withSize(30)
        return $0
    }(UILabel())
    
    private var authorLabel: UILabel = {
        $0.lineBreakMode = .byWordWrapping
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .preferredFont(forTextStyle: .subheadline).withSize(17)
        $0.textColor = .gray
        return $0
    }(UILabel())
    
    private var descriptionLabel: UILabel = {
        $0.lineBreakMode = .byWordWrapping
        $0.textAlignment = .natural
        $0.numberOfLines = 0
        $0.font = .preferredFont(forTextStyle: .body).withSize(15)
        return $0
    }(UILabel())
    
    private var book: Book? {
        didSet {
            setupViews()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addAutolayoutSubviews(thumbnail, scrollView)
        
        scrollView.addAutolayoutSubview(scrollViewContent)
        scrollViewContent.addAutolayoutSubviews(bookLabel, authorLabel, descriptionLabel)
        
        presenter.showBookDetails()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayout()
    }
    
}

extension DetailViewController: DetailViewProtocol {
    func showBookDetails(_ book: Book?) {
        self.book = book
    }
}

extension DetailViewController {
    private func setupViews() {
        guard let book = book else { print("Book is nil"); return }
        
        let imageService = ImageDownloadService()
        let thumbnailURL = book.volumeInfo.imageLinks.thumbnail
        
        imageService.downloadImage(from: thumbnailURL!) { image in
            DispatchQueue.main.async { [weak self] in
                self?.thumbnail.image = image
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.bookLabel.text = book.volumeInfo.title
            self?.authorLabel.text = book.volumeInfo.authors?.joined(separator: ", ")
            self?.descriptionLabel.text = book.volumeInfo.description
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            thumbnail.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            thumbnail.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            thumbnail.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            thumbnail.heightAnchor.constraint(equalToConstant: 300),
            
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scrollView.topAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            scrollViewContent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContent.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            bookLabel.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 20),
            bookLabel.topAnchor.constraint(equalTo: scrollViewContent.topAnchor, constant: 20),
            bookLabel.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -20),
            
            authorLabel.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 40),
            authorLabel.topAnchor.constraint(equalTo: bookLabel.bottomAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -40),
            authorLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.topAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: scrollViewContent.bottomAnchor)
        ])
    }
}
