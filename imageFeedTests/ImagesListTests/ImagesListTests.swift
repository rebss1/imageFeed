//
//  ImagesListTests.swift
//  imageFeedTests
//
//  Created by Илья Лощилов on 21.05.2024.
//

@testable import imageFeed
import Foundation
import XCTest

final class ImagesListTests: XCTest {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
    
    func testUpdateTableViewAnimated() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.updateTableViewAnimated()
        
        // then
        XCTAssertTrue(viewController.didUpdateTableViewAnimated)
    }
}
