//
//  Day.swift
//  GoGoPlan
//
//  Created by mwpark on 2/4/25.
//

import Foundation
import SwiftData
/*
@Model
class Day {
    var id: String = ""
    var places: [Place] = []
    var memos: [Memo] = []
    
    init(id: String = "", places: [Place] = [], memos: [Memo] = []) {
        self.id = id
        self.places = places
        self.memos = memos
    }
}
*/

@Model
class Day {
    var id: String
    var date: Date
    var dayNumber: Int
    var places: [Place]
    var memos: [Memo]
    
    init(id: String = UUID().uuidString,
         date: Date,
         dayNumber: Int,
         places: [Place] = [],
         memos: [Memo] = []) {
        self.id = id
        self.date = date
        self.dayNumber = dayNumber
        self.places = places
        self.memos = memos
    }
}
