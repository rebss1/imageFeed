//
//  WebViewViewControllerSpy.swift
//  imageFeedTests
//
//  Created by Илья Лощилов on 21.05.2024.
//

import imageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: (any imageFeed.WebViewPresenterProtocol)?
    var loadCalled: Bool = false
    
    func load(request: URLRequest) {
        loadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
