//
//  AuthConstants.swift
//  imageFeed
//
//  Created by Илья Лощилов on 12.03.2024.
//

import Foundation

enum AuthConstants {
    static let accessKey = "RB4n0Frd6mqPTYOJHbnu8vWsI3dMQgv_s5zI7iE3s1k"
    static let secretKey = "7CACemI_XVPjaVPHMosSc4aeukK6zSAyN0tykYX4YEg"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"

    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let pathToToken = "/oauth/token"
    static let hostToken = "unsplash.com"
    static let redirectPath = "/oauth/authorize/native"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: AuthConstants.accessKey,
                                     secretKey: AuthConstants.secretKey,
                                     redirectURI: AuthConstants.redirectURI,
                                     accessScope: AuthConstants.accessScope,
                                     authURLString: AuthConstants.unsplashAuthorizeURLString)
        }
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
