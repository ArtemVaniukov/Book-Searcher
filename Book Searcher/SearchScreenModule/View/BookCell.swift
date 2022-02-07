//
//  BookCell.swift
//  Book Searcher
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import UIKit


class BookCell: UITableViewCell {
    
    private lazy var thumbnailView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private var mainLabel: UILabel = {
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.font = .boldSystemFont(ofSize: 20)
        return $0
    }(UILabel())
    
    private var additionalLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .body, compatibleWith: .current).withSize(15)
        $0.textColor = .gray
        return $0
    }(UILabel())
    
    private var book: Book? {
        didSet { setupViews() }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        addAutolayoutSubviews(thumbnailView, mainLabel, additionalLabel)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupCell(with book: Book) {
        self.book = book
    }
        
}

extension BookCell {
    private func setupViews() {
        guard let book = book else { return }
        
        mainLabel.text = book.volumeInfo.title
        additionalLabel.text = book.volumeInfo.authors?.joined(separator: ", ")
        
        guard let url = book.volumeInfo.imageLinks?.smallThumbnail else {
            thumbnailView.image = UIImage(named: "noImage")
            return
        }
        
        let imageDownloadService = ImageDownloadService()
        imageDownloadService.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.thumbnailView.image = image
            }
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            thumbnailView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            thumbnailView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10),
            thumbnailView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10),
            thumbnailView.centerYAnchor.constraint(equalTo: centerYAnchor),
            thumbnailView.heightAnchor.constraint(equalToConstant: 60),
            thumbnailView.widthAnchor.constraint(equalToConstant: 60),
            
            mainLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 10),
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mainLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            additionalLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 10),
            additionalLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
            additionalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            additionalLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
