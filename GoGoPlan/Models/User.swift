import Foundation
import SwiftData


enum LoginType: String, Codable {
    case google
    case none  // 둘러보기용
}

@Model
class User {
    var id: String
    var email: String
    var loginType: LoginType
    var name: String?
    var profileUrl: String?
    
    init(id: String = UUID().uuidString, email: String = "", loginType: LoginType = .none, name: String? = nil, profileUrl: String? = nil) {
        self.id = id
        self.email = email
        self.loginType = loginType
        self.name = name
        self.profileUrl = profileUrl
    }
}
