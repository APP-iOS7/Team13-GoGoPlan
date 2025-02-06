import Foundation
import SwiftData

@Model

// 나의 일정에서 보이는 Day의 정보
class Day {
    // Day 구분 id
    var id: String
    // Day
    var date: Date
    // Day 1, 2, 3 에서 숫자를 나타냄
    var dayNumber: Int
    // 장소 추가했을 때의 장소들
    var places: [Place]
    // 메모
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
