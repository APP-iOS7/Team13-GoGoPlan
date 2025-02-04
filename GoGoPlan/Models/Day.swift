//
//  Day.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

// 2/4 밤 추가
import SwiftData
import Foundation

@Model
final class Day {
    var id: String
    var places: [Place]
    var memos: [Memo]
    
    init(id: String, places: [Place] = [], memos: [Memo] = []) {
        self.id = id
        self.places = places
        self.memos = memos
    }
}
