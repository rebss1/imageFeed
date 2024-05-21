
import Foundation
import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    let blackColor = UIColor(named: "ypBlack")
    private let profileService = ProfileService.shared
    private let storage = OAuthTokenStorage()
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = storage.token {
            fetchProfile(token)
        } else {
            switchToAuthViewController()
        }
    }
    
    private func switchToAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.navigationBar.topItem?.title = ""
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func addConstraints() {
        view.backgroundColor = blackColor
        let image = UIImage(named: "launchScreenIcon")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 78).isActive = true
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthetificate(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        fetchOAuthToken(code)
    }
    
    private func fetchOAuthToken(_ code: String) {
        OAuthService.shared.fetchOAuthToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self?.storage.store(token: token)
                    self?.fetchProfile(token)
                    self?.switchToTabBarController()
                case .failure:
                    break
                }
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.animate()
        profileService.fetchProfile(token) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                UIBlockingProgressHUD.dismiss()
                switch result {
                case .success(let profile):
                    self?.profileImageService.fetchProfileImageURL(profile.username) { _ in }
                    self?.switchToTabBarController()
                case .failure:
                    let alert = UIAlertController(title: "OOOPS!",
                                                  message: "Something went wrong with Unsplash API(",
                                                  preferredStyle: .alert)
                    self?.present(alert, animated: true)
                    break
                }
            }
        }
    }
}
