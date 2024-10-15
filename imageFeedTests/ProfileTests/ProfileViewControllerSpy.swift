//
//  ProfileViewControllerSpy.swift
//  imageFeedTests
//
//  Created by Илья Лощилов on 21.05.2024.
//

import imageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: (any imageFeed.ProfilePresenterProtocol)?
    var isAlertWasShown: Bool = false
    
    func showAlert(data: imageFeed.AlertData) {
        isAlertWasShown = true
    }
}
