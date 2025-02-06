import Foundation

// 공통 API 응답 구조를 정의하는 모델
// 제네릭 T를 사용하여 다양한 데이터 타입을 처리할 수 있도록 설계됨
struct TourAPIResponse<T: Decodable>: Decodable {
    let response: Response<T> // 최상위 응답 객체
}

// 응답 데이터를 포함하는 구조체
struct Response<T: Decodable>: Decodable {
    let header: Header // 응답 헤더 (결과 코드 및 메시지 포함)
    let body: Body<T>  // 응답 바디 (데이터 및 페이지 정보 포함)
}

// API 응답 헤더 구조체
// API 요청 결과 코드 및 메시지를 포함함
struct Header: Decodable {
    let resultCode: String // 결과 코드 (예: "0000"이면 성공)
    let resultMsg: String  // 결과 메시지 (예: "OK" 또는 오류 메시지)
}

// API 응답 바디 구조체
// 데이터 리스트와 페이지네이션 정보를 포함함
struct Body<T: Decodable>: Decodable {
    let items: Items<T>  // 실제 데이터 리스트
    let numOfRows: Int   // 한 페이지당 결과 개수
    let pageNo: Int      // 현재 페이지 번호
    let totalCount: Int  // 전체 데이터 개수
}

// API 응답에서 데이터를 감싸는 구조체
struct Items<T: Decodable>: Decodable {
    let item: [T] // 데이터를 배열로 저장
}

// 관광지 데이터 전송 객체 (DTO)
// API에서 받아오는 원본 데이터를 앱에서 사용할 모델로 변환하기 위한 구조체
struct PlaceDTO: Decodable {
    let contentid: String     // 관광지 ID
    let title: String         // 관광지 이름
    let addr1: String         // 기본 주소
    let addr2: String?        // 상세 주소 (옵션 값)
    let mapx: String          // 경도 (문자열 형태)
    let mapy: String          // 위도 (문자열 형태)
    let firstimage: String?   // 대표 이미지 URL (옵션 값)
    let contenttypeid: String? // 관광지 유형 (옵션 값)
    
    // DTO 데이터를 앱에서 사용할 Place 모델로 변환
    var toPlace: Place {
        Place(
            id: contentid, // 고유 ID 설정
            name: title,   // 관광지 이름
            address: [addr1, addr2].compactMap { $0 }.joined(separator: " "), // addr1과 addr2를 합쳐서 주소 생성
            imageUrl: firstimage, // 대표 이미지 URL
            latitude: Double(mapy) ?? 0, // 위도 값을 문자열에서 Double로 변환 (변환 실패 시 0으로 설정)
            longitude: Double(mapx) ?? 0, // 경도 값을 문자열에서 Double로 변환 (변환 실패 시 0으로 설정)
            category: contenttypeid // 관광지 유형
        )
    }
}
