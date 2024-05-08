//
//  PhotoResult.swift
//  imageFeed
//
//  Created by Илья Лощилов on 06.05.2024.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt, updatedAt: Date?
    let width, height: Int
    let color, blurHash: String?
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let user: User
    let urls: Urls
    let links: PhotoResultLinks
}

// MARK: - PhotoResponseLinks
struct PhotoResultLinks: Decodable {
    let html, download, downloadLocation: String?
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}

// MARK: - User
struct User: Decodable {
    let id, username, name: String
    let portfolioURL, bio, location: String?
    let totalLikes, totalPhotos, totalCollections: Int
    let instagramUsername, twitterUsername: String?
    let profileImage: ProfileImage
    let links: UserLinks
}

// MARK: - UserLinks
struct UserLinks: Decodable {
    let html, photos, likes, portfolio: String?
}
