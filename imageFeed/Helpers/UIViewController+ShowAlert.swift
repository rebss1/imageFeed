//
//  File.swift
//  imageFeed
//
//  Created by Илья Лощилов on 21.05.2024.
//

import Foundation
import UIKit

struct Action {
    let buttonText: String
    let action: (() -> Void)?
    let style: UIAlertAction.Style
}

struct AlertData {
    let title: String
    let message: String
    let actions: [Action]
}

private let defaultAlertData = AlertData(
    title: "Что-то пошло не так(",
    message: "Не удалось войти в систему",
    actions: [Action(buttonText: "ОК", action: nil, style: .default)]
)

extension UIViewController {
    func showAlert(alertData: AlertData = defaultAlertData) {
        let alert = UIAlertController(title: alertData.title, message: alertData.message, preferredStyle: .alert)
        alertData.actions.forEach { action in
            func handler(_: UIAlertAction) {
                guard let action = action.action else { return }
                action()
            }
            let action = UIAlertAction(title: action.buttonText, style: action.style, handler: handler)
            alert.addAction(action)
        }
        alert.view.accessibilityIdentifier = "alert"
        DispatchQueue.main.async {
            (self.presentedViewController ?? self).present(alert, animated: true, completion: nil)
        }
    }
}
