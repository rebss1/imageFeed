//
//  TabBarController.swift
//  imageFeed
//
//  Created by Илья Лощилов on 16.03.2024.
//

import Foundation
import UIKit
 
final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(identifier: "ImagesListViewController")
        
        guard var imagesListViewController = imagesListViewController as? ImagesListViewControllerProtocol else { return }
        let imageslistPresenter = ImagesListPresenter()
        imageslistPresenter.view = imagesListViewController
        imagesListViewController.presenter = imageslistPresenter
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profilePresenter.view = profileViewController
        profileViewController.presenter = profilePresenter
        
        profileViewController.tabBarItem = UITabBarItem(title: "",
                                                        image: UIImage(named: "tab_profile_active"),
                                                        selectedImage: nil)
        
        guard var imagesListViewController = imagesListViewController as? UIViewController else { return }
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
