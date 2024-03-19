
import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    private let authToken = OAuthTokenStorage().token
    private let networkClient = NetworkClient.shared
    private let profileService = ProfileService.shared
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastUsername: String?
    private (set) var avatarURL: String?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
       
    func fetchProfileImageURL(_ username: String,
                              completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let request = URLRequest.makeUrlRequest(httpMethod: HTTPMethods.get.rawValue, host: NetworkConstants.host, path: "\(ProfileConstants.usersPublicProfilePath)\(username)", queryItems: nil)
        
        networkClient.fetch(urlRequest: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profile):
                guard let profileImageURL = profile.profileImage?.large else { return }
                self?.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageURL])
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
}
