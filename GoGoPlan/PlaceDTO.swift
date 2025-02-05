import Foundation

// 공통 API 응답 구조
struct TourAPIResponse<T: Decodable>: Decodable {
    let response: Response<T> // 최상위 응답 객체
}

struct Response<T: Decodable>: Decodable {
    let header: Header // 응답 헤더
    let body: Body<T>  // 응답 바디
}

// 응답 헤더 (결과 코드 및 메시지 포함)
struct Header: Decodable {
    let resultCode: String
    let resultMsg: String
}

// 응답 바디 (데이터 및 페이지 정보 포함)
struct Body<T: Decodable>: Decodable {
    let items: Items<T>
    let numOfRows: Int  // 페이지당 결과 수
    let pageNo: Int     // 현재 페이지 번호
    let totalCount: Int // 전체 결과 개수
}

// 실제 데이터 리스트
struct Items<T: Decodable>: Decodable {
    let item: [T] // 데이터 배열
}

// 관광지 데이터 전송 객체 (DTO)
struct PlaceDTO: Decodable {
    let contentid: String
    let title: String
    let addr1: String
    let addr2: String?
    let mapx: String
    let mapy: String
    let firstimage: String?
    let contenttypeid: String?
    
    // DTO를 앱에서 사용하는 모델로 변환
    var toPlace: Place {
        Place(
            id: contentid,
            name: title,
            address: [addr1, addr2].compactMap { $0 }.joined(separator: " "), // 주소 합치기
            imageUrl: firstimage,
            latitude: Double(mapy) ?? 0, // 문자열을 Double로 변환
            longitude: Double(mapx) ?? 0,
            category: contenttypeid
        )
    }
}
