//
//  Memo.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

import Foundation

struct Memo: Identifiable, Codable {
    let id: String
    var content: String
    var imageUrl: String?
    let createdAt: Date
}
