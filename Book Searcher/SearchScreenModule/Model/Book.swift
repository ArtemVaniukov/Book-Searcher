//
//  Book.swift
//  Book Searcher
//
//  Created by Artem Vaniukov on 07.02.2022.
//

import Foundation


struct BookResponse: Decodable {
    let kind: String
    let totalItems: Int
    let items: [Book]
}

struct Book: Decodable {
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Decodable {
    let title: String
    let authors: [String]
    // TODO: - Debug "description" error "keyNotFound" response
    //let description: String
    let imageLinks: ImageLinks
}

struct ImageLinks: Decodable {
    let smallThumbnail: String
    let thumbnail: String
}
