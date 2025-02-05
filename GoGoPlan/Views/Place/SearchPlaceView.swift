//
//  SearchPlaceView.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//


/*
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
*/

/*
import SwiftUI
import SwiftData

struct SearchPlaceView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedPlaces: Set<Place> = []
    @StateObject private var placeService = PlaceService()
    
    let day: Day
    init(day: Day, placeService: PlaceService = PlaceService()) {
        self.day = day
        self.placeService = placeService
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // 검색창
                TextField("장소를 검색해보세요", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // 선택된 장소들
                if !selectedPlaces.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Array(selectedPlaces)) { place in
                                SelectedPlaceChip(place: place) {
                                    selectedPlaces.remove(place)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                }
                
                // 검색 결과 또는 추천 장소
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if !searchText.isEmpty {
                            // 검색 결과
                            if let searchResults = placeService.searchResults {
                                ForEach(searchResults) { place in
                                    PlaceSearchRow(
                                        place: place,
                                        isSelected: selectedPlaces.contains(place)
                                    ) {
                                        if selectedPlaces.contains(place) {
                                            selectedPlaces.remove(place)
                                        } else {
                                            selectedPlaces.insert(place)
                                        }
                                    }
                                }
                            }
                        } else {
                            // 추천 장소
                            if let recommendedPlaces = placeService.recommendedPlaces {
                                ForEach(recommendedPlaces) { place in
                                    PlaceSearchRow(
                                        place: place,
                                        isSelected: selectedPlaces.contains(place)
                                    ) {
                                        if selectedPlaces.contains(place) {
                                            selectedPlaces.remove(place)
                                        } else {
                                            selectedPlaces.insert(place)
                                        }
                                    }
                                }
                                
                                if placeService.hasMorePlaces {
                                    Button("더보기") {
                                        Task {
                                            await placeService.loadMoreRecommendedPlaces()
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("장소 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("선택완료") {
                        // 선택된 장소들을 Day에 추가
                        day.places.append(contentsOf: selectedPlaces)
                        dismiss()
                    }
                    .disabled(selectedPlaces.isEmpty)
                }
            }
            .onChange(of: searchText) { newValue in
                // 검색어가 변경될 때마다 검색 실행
                Task {
                    await placeService.searchPlaces(keyword: newValue)
                }
            }
        }
    }
}

struct SelectedPlaceChip: View {
    let place: Place
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            if let imageUrl = place.imageUrl {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            }
            
            Text(place.name)
                .lineLimit(1)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.1))
        .clipShape(Capsule())
    }
}

struct PlaceSearchRow: View {
    let place: Place
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                if let imageUrl = place.imageUrl {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                }
                
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.headline)
                    Text(place.address)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Plan.self, configurations: config)
    
    let day = Day(date: Date(), dayNumber: 1)
    
    return SearchPlaceView(day: day)
        .modelContainer(container)
}
*/

import SwiftData
import SwiftUI

struct SearchPlaceView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedPlaces: Set<Place> = []
    @StateObject private var placeService = PlaceService.shared
    let day: Day
    
    var body: some View {
        NavigationView {
            VStack {
                // 검색창
                TextField("장소를 검색해보세요", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // 선택된 장소들
                if !selectedPlaces.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 12) {
                            ForEach(Array(selectedPlaces)) { place in
                                SelectedPlaceChip(place: place) {
                                    selectedPlaces.remove(place)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                }
                
                // 검색 결과 또는 추천 장소
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if !searchText.isEmpty {
                            // 검색 결과
                            if let searchResults = placeService.searchResults {
                                ForEach(searchResults) { place in
                                    PlaceSearchRow(
                                        place: place,
                                        isSelected: selectedPlaces.contains(place)
                                    ) {
                                        if selectedPlaces.contains(place) {
                                            selectedPlaces.remove(place)
                                        } else {
                                            selectedPlaces.insert(place)
                                        }
                                    }
                                }
                            }
                        } else {
                            // 추천 장소
                            if let recommendedPlaces = placeService.recommendedPlaces {
                                ForEach(recommendedPlaces) { place in
                                    PlaceSearchRow(
                                        place: place,
                                        isSelected: selectedPlaces.contains(place)
                                    ) {
                                        if selectedPlaces.contains(place) {
                                            selectedPlaces.remove(place)
                                        } else {
                                            selectedPlaces.insert(place)
                                        }
                                    }
                                }
                                
                                if placeService.hasMorePlaces {
                                    Button("더보기") {
                                        Task {
                                            await placeService.loadMoreRecommendedPlaces()
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("장소 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("선택완료") {
                        // 선택된 장소들을 Day에 추가
                        day.places.append(contentsOf: selectedPlaces)
                        dismiss()
                    }
                    .disabled(selectedPlaces.isEmpty)
                }
            }
            .onChange(of: searchText) { newValue in
                // 검색어가 변경될 때마다 검색 실행
                Task {
                    await placeService.searchPlaces(keyword: newValue)
                }
            }
        }
    }
}

struct SelectedPlaceChip: View {
    let place: Place
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            Text(place.name)
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}


struct PlaceSearchRow: View {
    let place: Place
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(place.name)
                Text(place.address)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onSelect) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}



#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Plan.self, configurations: config)
    
    let day = Day(date: Date(), dayNumber: 1)
    
    return SearchPlaceView(day: day)
        .modelContainer(container)
}
