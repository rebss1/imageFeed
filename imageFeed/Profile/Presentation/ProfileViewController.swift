import Foundation
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    let whiteColor = UIColor(named: "ypWhite")
    let whiteWithAlphaColor = UIColor(named: "ypWhite50")
    let redColor = UIColor(named: "ypRed")
    
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    var imageView = UIImageView()
    var nameLabel = UILabel()
    var loginNameLabel = UILabel()
    var bioLabel = UILabel()
    
    override func viewDidLoad() {
        addConstraints()
        updateProfileDetails()
        addObserver()
    }
    
    private func addObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateAvatar()
            }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 100)
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "profileImage"),
                              options: [.processor(processor)])
    }
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        bioLabel.text = profile.bio
    }
    
    private func addConstraints() {
        imageView.tintColor = .gray
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        nameLabel.text = "Name"
        nameLabel.textColor = whiteColor
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        
        loginNameLabel.text = "Username"
        loginNameLabel.textColor = whiteWithAlphaColor
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        bioLabel.text = "Description"
        bioLabel.textColor = whiteColor
        bioLabel.font = UIFont.systemFont(ofSize: 13)
        
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bioLabel)
        
        bioLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor).isActive = true
        bioLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        
        let button = UIButton.systemButton(with: UIImage(named: "logout_image")!,
                                           target: self,
                                           action: #selector(didTapBackButton))
        button.tintColor = redColor
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc private func didTapBackButton() {
        let alert = UIAlertController(title: "До свидания!",
                                      message: "Точно хотите выйти?",
                                      preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Да",
                                      style: .destructive) { _ in
            alert.dismiss(animated: true)
            self.profileLogoutService.logout()
        }
        let noButton = UIAlertAction(title: "Нет",
                                     style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true)
    }
}
    
    
