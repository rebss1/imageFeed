
import Foundation
import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    private let storage = OAuthTokenStorage()
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if OAuthTokenStorage().token != nil {
            guard let token = storage.token else { return }
                fetchProfile(token)
        } else {
            switchToAuthViewController()
        }
    }
    
    private func switchToAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
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
        let image = UIImage(named: "launchScreenIcon")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthetificate(_ vc: AuthViewController, didAuthenticateWithCode: String) {
        vc.dismiss(animated: true)
        guard let token = storage.token else { return }
        fetchProfile(token)
    }
    
    func fetchOAuthToken(_ code: String,
                         completion: @escaping (Result<String, Error>) -> Void) {
        OAuthService.shared.fetchOAuthToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    OAuthTokenStorage().store(token: token)
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
                    print("error in splashViewController")
                    break
                }
            }
        }
    }
}
