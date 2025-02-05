//
//  Place.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//
/*
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
*/

/*
import Foundation
import SwiftData

@Model
class Place: Identifiable {
    let id: String
    var name: String
    var address: String
    var imageUrl: String?
    
    init(id: String, name: String, address: String, imageUrl: String? = nil) {
        self.id = id
        self.name = name
        self.address = address
        self.imageUrl = imageUrl
    }
}
*/

/*
import Foundation
import SwiftData
import CoreLocation

@Model
class Place: Identifiable {
    var id: String
    var name: String
    var address: String
    var imageUrl: String?
    var latitude: Double
    var longitude: Double
    var category: String?
    
    init(id: String = UUID().uuidString,
         name: String,
         address: String,
         imageUrl: String? = nil,
         latitude: Double,
         longitude: Double,
         category: String? = nil) {
        self.id = id
        self.name = name
        self.address = address
        self.imageUrl = imageUrl
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
*/

import Foundation
import SwiftData
import CoreLocation

@Model
class Place: Identifiable {
    var id: String
    var name: String
    var address: String
    var imageUrl: String?
    var latitude: Double
    var longitude: Double
    var category: String?
    
    var isFavorite: Bool
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
