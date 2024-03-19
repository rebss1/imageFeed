
import Foundation
/*
struct ProfileResult: Codable {
    var id: String
    var updatedAt: String?
    var username: String
    var firstName, lastName: String?
    var twitterUsername: String?
    var portfolioURL: String?
    var bio: String?
    var location: String?
    var totalLikes, totalPhotos, totalCollections: Int?
    var followedByUser: Bool?
    var downloads, uploadsRemaining: Int?
    var instagramUsername, email: String?
    //var links: [String?]

    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio
        case location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case followedByUser = "followed_by_user"
        case downloads
        case uploadsRemaining = "uploads_remaining"
        case instagramUsername = "instagram_username"
        case email
        //case links
    }
}*/

struct ProfileResult: Codable {
    var id: String
    //var updatedAt: String?
    var username: String
    var name, firstName, lastName: String?
    //var instagramUsername, twitterUsername: String?
    //var portfolioURL: String?
    var bio: String?
    //var location: String?
    //var totalLikes, totalPhotos, totalCollections: Int?
    //var followedByUser: Bool?
    //var followersCount, followingCount, downloads: Int?
    //var social: Social?
    var profileImage: ProfileImage?
    //var badge: Badge?
    //var links: Links?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        //case updatedAt = "updated_at"
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        //case instagramUsername = "instagram_username"
        //case twitterUsername = "twitter_username"
        //case portfolioURL = "portfolio_url"
        case bio
        //case location
        //case totalLikes = "total_likes"
        //case totalPhotos = "total_photos"
        //case totalCollections = "total_collections"
        //case followedByUser = "followed_by_user"
        //case followersCount = "followers_count"
        //case followingCount = "following_count"
        //case downloads, social
        case profileImage = "profile_image"
        //case badge, links
    }
}
/*
// MARK: - Badge
struct Badge: Codable {
    var title: String?
    var primary: Bool?
    var slug: String?
    var link: String?
}

// MARK: - Links
struct Links: Codable {
    var linksSelf, html, photos, likes: String?
    var portfolio: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio
    }
}*/

// MARK: - ProfileImage
struct ProfileImage: Codable {
    var small, medium, large: String?
}
/*
// MARK: - Social
struct Social: Codable {
    var instagramUsername, portfolioURL, twitterUsername: String?

    enum CodingKeys: String, CodingKey {
        case instagramUsername = "instagram_username"
        case portfolioURL = "portfolio_url"
        case twitterUsername = "twitter_username"
    }
}*/
