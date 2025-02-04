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
