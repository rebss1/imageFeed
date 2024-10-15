//
//  ProfilePresenterSpy.swift
//  imageFeedTests
//
//  Created by Илья Лощилов on 21.05.2024.
//

import imageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: (any imageFeed.ProfileViewControllerProtocol)?
    
    func getProfileImageURL() -> URL? {
        return nil
    }
    
    func didTapLogoutButton() {
    }
    
    func getProfile() -> imageFeed.Profile? {
        return nil
    }
    
    
}
