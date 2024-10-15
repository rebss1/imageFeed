
import Foundation

public struct Profile: Codable {
    var username: String
    var name: String
    var loginName: String
    var bio: String
    
    static func convertProfile(_ profileResult: ProfileResult) -> Profile{
        return Profile(
            username: profileResult.username,
            name: "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")" ,
            loginName: "@\(profileResult.username)",
            bio: profileResult.bio ?? ""
        )
    }
}
