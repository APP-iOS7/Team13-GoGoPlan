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
