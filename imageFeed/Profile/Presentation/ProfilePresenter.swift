//
//  ProfilePresenter.swift
//  imageFeed
//
//  Created by Илья Лощилов on 21.05.2024.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func getProfileImageURL() -> URL?
    func didTapLogoutButton()
    func getProfile() -> Profile?
}

final class ProfilePresenter: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    private var profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private let profileImageService = ProfileImageService.shared

        
    func getProfileImageURL() -> URL? {
        guard
            let profileImageURL = profileImageService.avatarURL
        else { return nil }
        return URL(string: profileImageURL)
    }
    
    func didTapLogoutButton() {
        let alertData = AlertData(title: "До свидания!",
                                  message: "Точно хотите выйти?",
                                  actions: [Action(buttonText: "Нет", action: nil, style: .cancel),
                                  Action(buttonText: "Да", action: logout, style: .destructive)])
        view?.showAlert(data: alertData)
    }
                                
    private func logout() {
        profileLogoutService.logout()
    }
    
    func getProfile() -> Profile? {
        return profileService.profile
    }
}
