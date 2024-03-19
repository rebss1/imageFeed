//
//  AuthConstants.swift
//  imageFeed
//
//  Created by Илья Лощилов on 12.03.2024.
//

import Foundation

struct AuthConstants {
    static let accessKey = "RB4n0Frd6mqPTYOJHbnu8vWsI3dMQgv_s5zI7iE3s1k"
    static let secretKey = "7CACemI_XVPjaVPHMosSc4aeukK6zSAyN0tykYX4YEg"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"

    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let pathToToken = "/oauth/token"
    static let hostToken = "unsplash.com"
    static let redirectPath = "/oauth/authorize/native"
}

enum AuthKeys: String {
    case clientID = "client_id"
    case clientSecret = "client_secret"
    case redirectUri = "redirect_uri"
    case responseType = "response_type"
    case grantType = "grant_type"
    case scope = "scope"
    case code = "code"
    case authorizationCode = "authorization_code"
    case bearer = "Bearer"
    case authorization = "Authorization"
}
