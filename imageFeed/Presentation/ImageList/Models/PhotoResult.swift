//
//  PhotoResult.swift
//  imageFeed
//
//  Created by Илья Лощилов on 06.05.2024.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt, updatedAt: Date?
    let width, height: Int
    let color, blurHash: String?
    let likes: Int?
    let likedByUser: Bool
    let description: String?
    let urls: Urls
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}
