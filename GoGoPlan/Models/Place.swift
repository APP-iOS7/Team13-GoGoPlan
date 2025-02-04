//
//  Place.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

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
