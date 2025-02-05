import Foundation

struct TourAPIResponse<T: Decodable>: Decodable {
    let response: Response<T>
}

struct Response<T: Decodable>: Decodable {
    let header: Header
    let body: Body<T>
}

struct Header: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct Body<T: Decodable>: Decodable {
    let items: Items<T>
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct Items<T: Decodable>: Decodable {
    let item: [T]
}

struct PlaceDTO: Decodable {
    let contentid: String
    let title: String
    let addr1: String
    let addr2: String?
    let mapx: String
    let mapy: String
    let firstimage: String?
    let contenttypeid: String?
    
    var toPlace: Place {
        Place(
            id: contentid,
            name: title,
            address: [addr1, addr2].compactMap { $0 }.joined(separator: " "),
            imageUrl: firstimage,
            latitude: Double(mapy) ?? 0,
            longitude: Double(mapx) ?? 0,
            category: contenttypeid
        )
    }
}
