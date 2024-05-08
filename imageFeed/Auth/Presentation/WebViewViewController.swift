
import Foundation
import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    let greyColor = UIColor(named: "ypGrey")
    let blackColor = UIColor(named: "ypBlack")
    
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = blackColor
        progressView.trackTintColor = greyColor
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
        
        webView.navigationDelegate = self
        
        estimatedProgressObservation = webView.observe(
                    \.estimatedProgress,
                    options: [],
                    changeHandler: { [weak self] _, _ in
                        guard let self = self else { return }
                        self.updateProgress()
                    })
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProgress()
    }
    
    override func loadView() {
        super.loadView()
        loadWebView()
    }
    
    private func loadWebView() {
        guard 
            var urlComponents = URLComponents(string: AuthConstants.unsplashAuthorizeURLString)
        else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: AuthKeys.clientID.rawValue, value: AuthConstants.accessKey),
            URLQueryItem(name: AuthKeys.redirectUri.rawValue, value: AuthConstants.redirectURI),
            URLQueryItem(name: AuthKeys.responseType.rawValue, value: AuthKeys.code.rawValue),
            URLQueryItem(name: AuthKeys.scope.rawValue, value: AuthConstants.accessScope)
        ]
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func addSubviews() {
        view.addSubview(webView)
        view.addSubview(progressView)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == AuthConstants.redirectPath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == AuthKeys.code.rawValue })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
