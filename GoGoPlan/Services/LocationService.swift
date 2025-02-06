import Foundation

protocol LocationServiceProtocol {
    // 장소의 위치(위도, 경도) 값을 리턴
    func getCurrentLocation() async throws -> (latitude: Double, longitude: Double)
    // 위치 권한 요청 함수
    func requestLocationPermission() async throws
}
