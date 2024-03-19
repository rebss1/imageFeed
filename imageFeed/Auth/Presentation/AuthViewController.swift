
import Foundation
import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthetificate(_ vc: AuthViewController, didAuthenticateWithCode: String)
    func fetchOAuthToken(_ code: String,
                         completion: @escaping (Result<String, Error>) -> Void)
}

final class AuthViewController: UIViewController {
    let whiteColor = UIColor(named: "YP White")
    let blackColor = UIColor(named: "YP Black")
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuthService.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = whiteColor
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(blackColor, for: .normal)
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "UnsplashLogo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @objc private func didTapLoginButton() {
        let webViewViewController = WebViewViewController()
        webViewViewController.delegate = self
        self.navigationController?.pushViewController(webViewViewController, animated: true)
    }
    
    private func configureAlert() -> UIAlertController{
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        return alert
    }
    
    private func addSubviews() {
        view.backgroundColor = blackColor
        view.addSubview(logoImage)
        view.addSubview(loginButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        DispatchQueue.main.async{
            vc.dismiss(animated: true)
            UIBlockingProgressHUD.animate()
            
            self.delegate?.fetchOAuthToken(code) { [weak self] result in
                guard let self = self else { return }
                UIBlockingProgressHUD.dismiss()
                
                switch result {
                case .success:
                    self.delegate?.didAuthetificate(self, didAuthenticateWithCode: code)
                case .failure:
                    let alert = configureAlert()
                    self.present(alert, animated: true)
                    break
                }
            }
        }
    }
        
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
