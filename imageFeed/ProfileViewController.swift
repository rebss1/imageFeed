//
//  ProfileViewController.swift
//  imageFeed
//
//  Created by Илья Лощилов on 22.01.2024.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    let whiteColor = UIColor(named: "YP White")
    let whiteWithAlphaColor = UIColor(named: "YP White (Alpha 50)")
        
    override func viewDidLoad() {
        let image = UIImage(named: "profile_image")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .gray
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let firstLabel = UILabel()
        firstLabel.text = "Name"
        firstLabel.textColor = whiteColor
        firstLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstLabel)
        
        firstLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        firstLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        
        let secondLabel = UILabel()
        secondLabel.text = "Username"
        secondLabel.textColor = whiteWithAlphaColor
        secondLabel.font = UIFont.systemFont(ofSize: 13)
        
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondLabel)
        
        secondLabel.leadingAnchor.constraint(equalTo: firstLabel.leadingAnchor).isActive = true
        secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 8).isActive = true
        
        let thirdLabel = UILabel()
        thirdLabel.text = "Description"
        thirdLabel.textColor = whiteColor
        thirdLabel.font = UIFont.systemFont(ofSize: 13)
        
        thirdLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thirdLabel)
        
        thirdLabel.leadingAnchor.constraint(equalTo: secondLabel.leadingAnchor).isActive = true
        thirdLabel.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: 8).isActive = true
        
        let button = UIButton.systemButton(with: UIImage(named: "logout_image")!,
                                           target: self,
                                           action: nil)
        button.tintColor = .red
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
}
