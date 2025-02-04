//
//  Plan.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

import Foundation
import SwiftData

@Model
class Plan {
    var id: String
    var region: String
    var date: Date
    var days: [Day]
    
    init(id: String = UUID().uuidString, region: String = "", date: Date = Date(), days: [Day] = [])
    {
        self.id = id
        self.region = region
        self.date = date
        self.days = days
    }}
