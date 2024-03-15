
import Foundation
import SwiftKeychainWrapper

final class OAuthTokenStorage {
    var token: String? {
        KeychainWrapper.standard.string(forKey: "Auth token")
    }
    
    func store(token: String?) {
        guard let token else {
            let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "Auth token")
            guard removeSuccessful else {
                print("error when deleting token")
                return
            }
            return
        }
        KeychainWrapper.standard.set(token, forKey: "Auth token")
    }
}
