
import Foundation

final class OAuth2TokenStorage {
    var token: String? {
        get{
            return UserDefaults.standard.string(forKey: "token")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "token")
        }
    }
}
