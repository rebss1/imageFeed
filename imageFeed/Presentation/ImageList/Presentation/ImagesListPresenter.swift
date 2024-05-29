//
//  ImagesListPresenter.swift
//  imageFeed
//
//  Created by Илья Лощилов on 21.05.2024.
//

import Foundation
import UIKit

public protocol ImagesListPresenterProtocol {
    var view : ImagesListViewControllerProtocol? { get set }
    func didTapLikeButton(cell: ImagesListCell)
    func fetchNextPhotos(indexPath: IndexPath)
    func getPhotos() -> [Photo]
    func getCellHeight(indexPath: IndexPath) -> CGFloat
    func updateTableViewAnimated()
    func viewDidLoad()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    
    private let imagesListService = ImagesListService.shared
    private var photosCount: Int = 0
    
    func viewDidLoad() {
        fetchPhotos()
        updateTableViewAnimated()
    }
    
    func didTapLikeButton(cell: ImagesListCell) {
        cell.likeButton.isEnabled = false
        guard let table = view?.getTable(),
              let indexPath = table.indexPath(for: cell) else { return }
        let photo = imagesListService.photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id,
                                     isLike: !photo.isLiked) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photo):
                    cell.setLike(photo.isLiked)
                case .failure:
                    let alertData = AlertData(title: "Упс!",
                                              message: "Что-то пошло не так(",
                                              actions: [Action(buttonText: "Ок", action: nil, style: .cancel)])
                    self?.view?.showAlert(data: alertData)
                    break
                }
                cell.likeButton.isEnabled = true
            }
        }
    }
    
    func fetchNextPhotos(indexPath: IndexPath = IndexPath()) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    private func fetchPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func getPhotos() -> [Photo] {
        imagesListService.photos
    }
    
    func getCellHeight(indexPath: IndexPath) -> CGFloat {
        guard let table = view?.getTable() else { return 0}
        let photo = imagesListService.photos[indexPath.row]
        let insets = ImagesListViewController.imageInsets
        let originalRatio =  photo.size.height / photo.size.width
        let imageViewWidth = table.bounds.width - insets.right - insets.left
        let cellHeight = imageViewWidth * originalRatio + insets.bottom
        return cellHeight
    }
    
    func updateTableViewAnimated() {
        let oldCount = photosCount
        let newCount = imagesListService.photos.count
        photosCount = imagesListService.photos.count
        if oldCount != newCount {
            view?.updateTableViewAnimated(from: oldCount, to: newCount)
        }
    }
}
