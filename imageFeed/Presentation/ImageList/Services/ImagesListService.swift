//
//  ImagesListService.swift
//  imageFeed
//
//  Created by Илья Лощилов on 17.03.2024.
//

import Foundation

final class ImagesListService {
    let shared = ImagesListService()
    private init() {}
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let networkClient = NetworkClient.shared
    
    func fethcPhotosNextPage() {
        assert(Thread.isMainThread)
        let nextPage = (lastLoadedPage ?? 0) + 1
        let queryItems = [
            URLQueryItem(name: ImagesListContants.page, value: "\(nextPage)"),
            URLQueryItem(name: ImagesListContants.perPage, value: ImagesListContants.photosPerPage)
            ]
        let request = URLRequest.makeUrlRequest(path: ImagesListContants.imagesListPath, queryItems: queryItems)
        
        networkClient.fetch(urlRequest: request) { [weak self] (result: Result<[PhotoResult],Error>) in
            switch result {
            case .success(let photosResult):
                self?.lastLoadedPage = nextPage
                DispatchQueue.main.async {
                    for photoResult in photosResult {
                        self?.photos.append(Photo(photoResult))
                    }
                }
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
            case .failure(let error):
                break
            }
        }
    }
}
