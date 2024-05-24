
import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case dataError
    case taskError
}

final class NetworkClient {
    static let shared = NetworkClient()
    private init() {}
    
    private weak var task: URLSessionTask?
    private let urlSession = URLSession.shared
    
    func fetch<Response: Decodable>(urlRequest: URLRequest,
                                    completion: @escaping (Result<Response, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completion(.failure(NetworkClientError.taskError))
                print("[imageFeed][fetch][\(String(describing: urlRequest.url ?? NetworkConstants.defaultBaseURL))]: [\(String(describing: error))]")
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                print("[imageFeed][fetch][\(String(describing: urlRequest.url ?? NetworkConstants.defaultBaseURL))]: [\(response.statusCode)]")
                return
            }
            
            if let data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoder.dateDecodingStrategy = .iso8601
                    let response = try decoder.decode(Response.self, from: data)
                    completion(.success(response))
                    self.task = nil
                } catch {
                    completion(.failure(error))
                    print("[imageFeed][fetch][\(String(describing: urlRequest.url ?? NetworkConstants.defaultBaseURL))]: [\(error)]")
                }
            }
        }
        self.task = task
        task.resume()
    }
}
