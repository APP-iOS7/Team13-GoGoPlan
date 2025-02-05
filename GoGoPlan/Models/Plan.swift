import Foundation
import SwiftData

@Model
class Plan {
    var id: String
    var region: String
    var startDate: Date
    var endDate: Date
    var days: [Day]
    var dateCreated: Date
    
    init(id: String = UUID().uuidString,
         region: String,
         startDate: Date,
         endDate: Date,
         days: [Day] = [], dateCreated: Date = Date()) {
        self.id = id
        self.region = region
        self.startDate = startDate
        self.endDate = endDate
        self.days = days
        self.dateCreated = dateCreated
    }
}




