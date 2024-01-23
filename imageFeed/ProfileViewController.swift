//
//  ProfileViewController.swift
//  imageFeed
//
//  Created by Илья Лощилов on 22.01.2024.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var acccoutTag: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var didTapLogoutButton: UIButton!
    
}
