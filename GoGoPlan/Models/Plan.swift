//
//  Plan.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

/*
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
*/
import Foundation
import SwiftData

@Model
final class Plan {
    var id: String
    var region: String
    var date: Date
    @Relationship(deleteRule: .cascade) var days: [Day]
    
    init(id: String, region: String, date: Date, days: [Day] = []) {
        self.id = id
        self.region = region
        self.date = date
        self.days = days
    }
}
