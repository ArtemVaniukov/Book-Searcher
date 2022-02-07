//
//  ImageDownloadService.swift
//  Book Searcher
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import UIKit


enum ImageDownloadError: Error {
    case badURL(String)
    case badData(String)
}

protocol ImageDownloadProtocol {
    func downloadImage(from url: String, completion: @escaping (Result<UIImage?, Error>) -> Void)
}

class ImageDownloadService: ImageDownloadProtocol {
    func downloadImage(from url: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(ImageDownloadError.badURL(url)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(ImageDownloadError.badData("Wrong image data")))
            }
        }.resume()
    }
    
}
