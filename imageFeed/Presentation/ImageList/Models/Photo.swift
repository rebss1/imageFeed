//
//  Photo.swift
//  imageFeed
//
//  Created by Илья Лощилов on 06.05.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(id: String, size: CGSize, createdAt: Date?, welcomeDescription: String?, thumbImageURL: String, largeImageURL: String, isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
    
    init(_ photoResult: PhotoResult) {
            self.id = photoResult.id
            self.size = CGSize(width: photoResult.width,
                               height: photoResult.height)
            self.createdAt = photoResult.createdAt
            self.welcomeDescription = photoResult.description
            self.thumbImageURL = photoResult.urls.small
            self.largeImageURL = photoResult.urls.full
            self.isLiked =  photoResult.likedByUser
        }
}
