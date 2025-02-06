import Foundation
import SwiftData
import CoreLocation

@Model

// API로 불러올 장소 데이터
class Place: Identifiable {
    // 장소의 id
    var id: String
    // 장소의 이름
    var name: String
    // 장소의 주소
    var address: String
    // 장소의 이미지 -> URL로 이미지 불러옴
    var imageUrl: String?
    // 장소의 위도 -> 맵에 위치를 표시하기 위함.
    var latitude: Double
    // 장소의 경도 -> 맵에 위치를 표시하기 위함.
    var longitude: Double
    // ?
    var category: String?
    // 즐겨찾기 유무
    var isFavorite: Bool
    // 장소 생성날짜 -> 일정에서 표시할 때 생성날짜 순으로 출력하기 위함.
    var createdAt: Date
    
    init(id: String = UUID().uuidString,
         name: String,
         address: String,
         imageUrl: String? = nil,
         latitude: Double,
         longitude: Double,
         category: String? = nil,
         isFavorite: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.address = address
        self.imageUrl = imageUrl
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
