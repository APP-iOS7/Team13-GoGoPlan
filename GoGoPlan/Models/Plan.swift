import Foundation
import SwiftData

@Model
class Plan {
    // 고유 식별자
    var id: String
    // 여행 지역
    var region: String
    // 여행 시작 날짜
    var startDate: Date
    // 여행 종료 날짜
    var endDate: Date
    // 여행 일정의 각 날을 나타내는 Day 객체 배열
    var days: [Day]
    // 계획이 생성된 날짜
    var dateCreated: Date
    
    // 초기화 메서드
    init(id: String = UUID().uuidString, // 기본값으로 UUID를 사용하여 고유 식별자를 생성
         region: String, // 여행 지역
         startDate: Date, // 여행 시작 날짜
         endDate: Date, // 여행 종료 날짜
         days: [Day] = [], // 기본값으로 빈 배열을 사용하여 여행 일정
         dateCreated: Date = Date()) { // 기본값으로 현재 날짜를 사용
        self.id = id
        self.region = region
        self.startDate = startDate
        self.endDate = endDate
        self.days = days
        self.dateCreated = dateCreated
    }
}



