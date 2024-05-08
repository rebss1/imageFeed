//
//  ImagesListConstants.swift
//  imageFeed
//
//  Created by Илья Лощилов on 07.05.2024.
//

import Foundation

struct ImagesListConstants {
    static let photosPath = "/photos"
    static let likePath = "/photos/:id/like"
    static let photosPerPage = "10"
}

enum ImagesListKeys: String {
    case page = "page"
    case perPage = "per_page"
    case id = "id"
}
