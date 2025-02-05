import Foundation
import SwiftData

@Model
class Plan {
    var id: String
    var region: String
    var startDate: Date
    var endDate: Date
    var days: [Day]
    
    init(id: String = UUID().uuidString,
         region: String,
         startDate: Date,
         endDate: Date,
         days: [Day] = []) {
        self.id = id
        self.region = region
        self.startDate = startDate
        self.endDate = endDate
        self.days = days
    }
}




