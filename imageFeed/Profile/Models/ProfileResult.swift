
import Foundation

struct ProfileResult: Codable {
    var id: String
    var username: String
    var name, firstName, lastName: String?
    var bio: String?
    var profileImage: ProfileImage?
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    var small, medium, large: String?
}
