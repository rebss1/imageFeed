//
//  ImagesListViewControllerSpy.swift
//  imageFeedTests
//
//  Created by Илья Лощилов on 22.05.2024.
//

import imageFeed
import Foundation
import UIKit

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: (any imageFeed.ImagesListPresenterProtocol)?
    var didUpdateTableViewAnimated: Bool = false
    
    func getTable() -> UITableView {
        UITableView()
    }
    
    func showAlert(data: imageFeed.AlertData) {
        
    }
    
    func updateTableViewAnimated(from: Int, to: Int) {
        didUpdateTableViewAnimated = true
    }
}
