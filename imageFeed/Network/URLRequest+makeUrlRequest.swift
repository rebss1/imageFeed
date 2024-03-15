
import Foundation

extension URLRequest {
    static func makeUrlRequest(
        httpMethod: String? = HTTPMethods.get.rawValue,
        host: String? = NetworkConstants.host,
        path: String?,
        queryItems: [URLQueryItem]?
    ) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkConstants.schema
        urlComponents.host = host
        urlComponents.path = path ?? ""
        urlComponents.queryItems = queryItems
        var urlRequest = URLRequest(url: urlComponents.url ?? NetworkConstants.defaultBaseURL)
        urlRequest.httpMethod = httpMethod
        if let token = OAuthTokenStorage().token {
            urlRequest.setValue("\(AuthKeys.bearer.rawValue) \(token)",
                                forHTTPHeaderField: AuthKeys.authorization.rawValue)
        } 
        return urlRequest
    }
}
