//
//  ProfileTests.swift
//  imageFeedTests
//
//  Created by Илья Лощилов on 21.05.2024.
//

@testable import imageFeed
import XCTest

final class ProfileTests: XCTestCase {
    func testAlertWasShown() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        presenter.view = viewController
        viewController.presenter = presenter
        
        //when
        presenter.didTapLogoutButton()
        
        //then
        XCTAssertTrue(viewController.isAlertWasShown)
    }
}
