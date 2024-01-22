//
//  SingleImageViewController.swift
//  imageFeed
//
//  Created by Илья Лощилов on 22.01.2024.
//

import Foundation
import UIKit

class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return } 
            imageView.image = image
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
