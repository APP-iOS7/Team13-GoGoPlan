import Foundation
import SwiftData

@Model

// Day 안에 들어갈 Memo 데이터
class Memo {
    // 메모 id 구분
    var id: String
    // 메모의 내용
    var content: String
    // 메모 안 이미지 추가시 사용할 URL -> URL로 이미지 불러옴
    var imageUrl: String?
    // 메모 생성한 날짜 -> 메모 추가시 id순이 아니라 메모를 생성한 시간 순으로 정렬하기 위함.
    var createdAt: Date
    
    init(id: String = UUID().uuidString,
         content: String,
         imageUrl: String? = nil,
         createdAt: Date = Date()) {
        self.id = id
        self.content = content
        self.imageUrl = imageUrl
        self.createdAt = createdAt
    }
}
