//
//  ImagesListService.swift
//  imageFeed
//
//  Created by Илья Лощилов on 06.05.2024.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    private init() {}
    
    private (set) var photos: [Photo] = []
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private var networkClient = NetworkClient.shared
    
    func fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage ?? 0) + 1
        if task != nil {
            assert(Thread.isMainThread)
            
            let queryItems = [
                URLQueryItem(name: ImagesListKeys.page.rawValue,
                             value: "\(nextPage)"),
                URLQueryItem(name: ImagesListKeys.perPage.rawValue,
                             value: ImagesListConstants.photosPerPage)]
            
            guard let request = URLRequest.makeUrlRequest(
                httpMethod: HTTPMethods.get.rawValue,
                host: NetworkConstants.host,
                path: ImagesListConstants.photosPath,
                queryItems: queryItems) else { return }
            
            networkClient.fetch(urlRequest: request) { [weak self] (result: Result<[PhotoResult], Error>) in
                switch result {
                case .success(let photos):
                    self?.lastLoadedPage = nextPage
                    let lastPhotos = photos.map { Photo($0) }
                    DispatchQueue.main.async {
                        self?.photos.append(contentsOf: lastPhotos)
                    }
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self)
                case .failure:
                    break
                }
            }
        }
    }
}
