
import Foundation

enum ProfileServiceError: Error {
    case invalidRequest
    case dataError
    case taskError
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    private let networkClient = NetworkClient.shared
    
    func fetchProfile(_ token: String,
                      completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = URLRequest.makeUrlRequest(httpMethod: HTTPMethods.get.rawValue, host: NetworkConstants.host, path: ProfileConstants.usersProfilePath, queryItems: nil) else { return }
        
        networkClient.fetch(urlRequest: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                let profile = Profile.convertProfile(profileResult)
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cleanData() {
        profile = nil
    }
}
