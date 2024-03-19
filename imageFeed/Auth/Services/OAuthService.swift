
import Foundation

final class OAuthService {
    static let shared = OAuthService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private let networkClient = NetworkClient.shared
    
    func fetchOAuthToken(code: String,
                         completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            print("[imageFeed][fetchAuthToken][\(AuthConstants.pathToToken)]: [the same code]")
            return
        }
        
        lastCode = code
        
        let queryItems = [
            URLQueryItem(name: AuthKeys.clientID.rawValue, value: AuthConstants.accessKey),
            URLQueryItem(name: AuthKeys.clientSecret.rawValue, value: AuthConstants.secretKey),
            URLQueryItem(name: AuthKeys.redirectUri.rawValue, value: AuthConstants.redirectURI),
            URLQueryItem(name: AuthKeys.code.rawValue, value: code),
            URLQueryItem(name: AuthKeys.grantType.rawValue, value: AuthKeys.authorizationCode.rawValue)]
        
        let request = URLRequest.makeUrlRequest(httpMethod: HTTPMethods.post.rawValue, host: AuthConstants.hostToken, path: AuthConstants.pathToToken, queryItems: queryItems)
        
        networkClient.fetch(urlRequest: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let body):
                completion(.success(body.accessToken))
                self?.lastCode = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

