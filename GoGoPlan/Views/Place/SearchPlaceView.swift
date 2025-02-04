//
//  SearchPlaceView.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

import SwiftUI

class SearchPlaceViewModel: ObservableObject {
    @Published var searchResults: [Place] = []
    @Published var selectedPlace: Place?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let placeService: PlaceServiceProtocol
    private let locationService: LocationServiceProtocol
    
    init(placeService: PlaceServiceProtocol, locationService: LocationServiceProtocol) {
        self.placeService = placeService
        self.locationService = locationService
    }
}
