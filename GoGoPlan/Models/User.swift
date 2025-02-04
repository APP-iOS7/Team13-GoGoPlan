/* 2/4 밤
import Foundation

enum LoginType: String, Codable {
    case google
    case none  // 둘러보기용
}

struct User: Codable {
    let id: String
    let email: String
    let loginType: LoginType
    let name: String?
    let profileUrl: String?
}
*/

import SwiftData

enum LoginType: String, Codable {
    case google
    case none  // 둘러보기용
}


@Model
final class User {
    var id: String
    var email: String
    var nickname: String
    var likedPlaces: [String]
    
    init(id: String, email: String, nickname: String, likedPlaces: [String] = []) {
        self.id = id
        self.email = email
        self.nickname = nickname
        self.likedPlaces = likedPlaces
    }
}
