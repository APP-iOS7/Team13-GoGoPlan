//
//  PlaceService.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

import Foundation

protocol PlaceServiceProtocol {
    func fetchRecommendedPlaces() async throws -> [Place]
    func searchPlaces(query: String, region: String) async throws -> [Place]
}
