//
//  ImagesListPresenterSpy.swift
//  imageFeedTests
//
//  Created by Илья Лощилов on 22.05.2024.
//

import imageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: imageFeed.ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func didTapLikeButton(cell: imageFeed.ImagesListCell) {
        
    }
    
    func fetchNextPhotos(indexPath: IndexPath) {
        
    }
    
    func getPhotos() -> [imageFeed.Photo] {
        []
    }
    
    func getCellHeight(indexPath: IndexPath) -> CGFloat {
        0
    }
    
    func updateTableViewAnimated() {
        
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    
}
