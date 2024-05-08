//
//  LikeResult.swift
//  imageFeed
//
//  Created by Илья Лощилов on 08.05.2024.
//

import Foundation

struct LikeResult: Decodable {
    let photo: PhotoResult
    let user: User
}
