//
//  LocationService.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

import Foundation

protocol LocationServiceProtocol {
    func getCurrentLocation() async throws -> (latitude: Double, longitude: Double)
    func requestLocationPermission() async throws
}
