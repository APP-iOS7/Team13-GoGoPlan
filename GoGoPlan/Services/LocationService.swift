import Foundation

protocol LocationServiceProtocol {
    func getCurrentLocation() async throws -> (latitude: Double, longitude: Double)
    func requestLocationPermission() async throws
}
