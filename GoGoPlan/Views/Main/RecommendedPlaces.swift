//
//  RecommendedPlaces.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

import SwiftUI

class RecommendedPlacesViewModel: ObservableObject {
    @Published var recommendedPlaces: [Place] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let placeService: PlaceServiceProtocol
    
    init(placeService: PlaceServiceProtocol) {
        self.placeService = placeService
    }
    
    @MainActor
    func fetchRecommendedPlaces() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            recommendedPlaces = try await placeService.fetchRecommendedPlaces()
        } catch {
            self.error = error
        }
    }
}
