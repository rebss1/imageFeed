//
//  Network Constants.swift
//  imageFeed
//
//  Created by Илья Лощилов on 12.03.2024.
//

import Foundation

struct NetworkConstants {
    //использую форс, потому что он в любом случае проходит, ведь там правильная строка, которая не меняется 
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let host = "api.unsplash.com"
    static let schema = "https"
}

enum HTTPMethods: String {
    case post = "POST"
    case get = "GET"
}
