//
//  Book.swift
//  Book Searcher
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import Foundation


struct BookResponse: Decodable {
    let items: [Book]
}

struct Book: Decodable {
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Decodable {
    let title: String?
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Decodable {
    let smallThumbnail: String?
    let thumbnail: String?
}
