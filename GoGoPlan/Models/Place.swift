//
//  Place.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

import Foundation
import SwiftData

@Model
class Place {
    var id: String
    var name: String
    var address: String
    var imageUrl: String?
    var region: String
    var operatingHours: String?
    var latitude: Double
    var longitude: Double
    
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
    
    init(id: String = "", name: String = "", address: String = "", imageUrl: String? = nil, region: String = "", operatingHours: String? = nil, latitude: Double = 0.0, longitude: Double = 0.0) {
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
