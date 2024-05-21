//
//  ProfileLogoutService.swift
//  imageFeed
//
//  Created by Илья Лощилов on 08.05.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private init() {}
    
    private let storage = OAuthTokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    
    func logout() {
        cleanCookies()
        cleanToken()
        cleanProfile()
        switchToAuth()
    }

    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanToken() {
        storage.store(token: nil)
    }
    
    private func cleanProfile() {
        profileService.cleanData()
        profileImageService.cleanData()
        imagesListService.cleanData()
    }
    
    private func switchToAuth() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            window.rootViewController = SplashViewController()
        }
    }
}
