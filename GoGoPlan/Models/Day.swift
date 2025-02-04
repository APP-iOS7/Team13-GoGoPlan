//
//  Day.swift
//  GoGoPlan
//
//  Created by mwpark on 2/4/25.
//

import Foundation
import SwiftData

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
