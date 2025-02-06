import Foundation
import SwiftData

@Model
class Memo {
    var id: String
    var content: String
    var imageUrl: String?
    var createdAt: Date
    
    init(id: String = UUID().uuidString,
         content: String,
         imageUrl: String? = nil,
         createdAt: Date = Date()) {
        self.id = id
        self.content = content
        self.imageUrl = imageUrl
        self.createdAt = createdAt
    }
}
