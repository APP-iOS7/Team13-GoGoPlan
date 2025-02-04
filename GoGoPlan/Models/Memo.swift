//
//  Memo.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

/* 2/4 밤
import Foundation

struct Memo: Identifiable, Codable {
    let id: String
    var content: String
    var imageUrl: String?
    let createdAt: Date
}
*/

import Foundation
import SwiftData

@Model
final class Memo {
    var id: String
    var content: String
    var imageUrl: String?
    var createdAt: Date
    
    init(id: String, content: String, imageUrl: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.content = content
        self.imageUrl = imageUrl
        self.createdAt = createdAt
    }
}
