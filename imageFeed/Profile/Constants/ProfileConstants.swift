//
//  ProfileConstants.swift
//  imageFeed
//
//  Created by Илья Лощилов on 12.03.2024.
//

import Foundation

struct ProfileConstants {
    static let usersProfilePath = "/me"
    static let usersPublicProfilePath = "/users/"
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
}
