//
//  Network Constants.swift
//  imageFeed
//
//  Created by Илья Лощилов on 12.03.2024.
//

import Foundation

struct NetworkConstants {
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let host = "api.unsplash.com"
    static let schema = "https"
}

enum HTTPMethods: String {
    case post = "POST"
    case get = "GET"
}
