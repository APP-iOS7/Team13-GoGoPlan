//
//  Plan.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

import Foundation

struct Plan: Identifiable, Codable {
    let id: String
    var region: String
    var date: Date
    var days: [Day]
    
    struct Day: Identifiable, Codable {
        let id: String
        var places: [Place]
        var memos: [Memo]
    }
}
