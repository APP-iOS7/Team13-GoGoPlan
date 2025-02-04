//
//  Place.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

/* 2/4 밤
import Foundation

struct Place: Identifiable, Codable {
    let id: String
    let name: String
    let address: String
    let imageUrl: String
    let region: String
    var operatingHours: String?
    let latitude: Double
    let longitude: Double
    
    // 문화체육관광부 API 응답 매핑을 위한 CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "contentid"
        case name = "title"
        case address = "addr1"
        case imageUrl = "firstimage"
        case region = "areacode"
        case operatingHours = "usetime"
        case latitude = "mapy"
        case longitude = "mapx"
    }
}
*/

import SwiftData

@Model
final class Place {
    var id: String
    var name: String
    var address: String
    var imageUrl: String
    var region: String
    var operatingHours: String?
    var latitude: Double
    var longitude: Double
    
    init(id: String, name: String, address: String, imageUrl: String, region: String, operatingHours: String? = nil, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.address = address
        self.imageUrl = imageUrl
        self.region = region
        self.operatingHours = operatingHours
        self.latitude = latitude
        self.longitude = longitude
    }
}
