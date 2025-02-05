import Foundation

struct PlaceDTO: Decodable {
    let contentid: String
    let title: String
    let addr1: String
    let addr2: String?
    let mapx: String
    let mapy: String
    let firstimage: String?
    let cat1: String?
    let cat2: String?
    let cat3: String?
    
    var toPlace: Place {
        Place(
            id: contentid,
            name: title,
            address: [addr1, addr2].compactMap { $0 }.joined(separator: " "),
            imageUrl: firstimage,
            latitude: Double(mapy) ?? 0,
            longitude: Double(mapx) ?? 0,
            category: [cat1, cat2, cat3].compactMap { $0 }.first
        )
    }
}
