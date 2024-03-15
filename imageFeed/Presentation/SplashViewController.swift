
import Foundation
import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    private let storage = OAuthTokenStorage()
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if OAuthTokenStorage().token != nil {
            guard let token = storage.token else { return }
                fetchProfile(token)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
