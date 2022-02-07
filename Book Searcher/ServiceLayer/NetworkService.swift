//
//  NetworkService.swift
//  Book Searcher
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import Foundation


enum NetworkServiceError: Error {
    case badURL(String)
    case badData(String)
}

protocol NetworkServiceProtocol {
    func fetchBooks(with query: String, completion: @escaping (Result<[Book]?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    func fetchBooks(with query: String, completion: @escaping (Result<[Book]?, Error>) -> Void) {
        let baseURLString = "https://www.googleapis.com/books/v1/volumes?q="
        
        guard let url = URL(string: baseURLString + query) else {
            completion(.failure(NetworkServiceError.badURL("URL or query you've entered is incorrect. Try to change it and search again.")))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkServiceError.badData("Unable to get books. Try again later.")))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(BookResponse.self, from: data)
                completion(.success(response.items))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
