import Foundation
import SwiftUI

@MainActor
class PlaceService: ObservableObject {
    @Published var recommendedPlaces: [Place]?
    @Published var searchResults: [Place]?
    @Published var error: Error?
    @Published var hasMorePlaces = false
    
    private var currentPage = 1
    private let pageSize = 20
    private var isLoading = false
    
    public init() {
        Task {
            await fetchRecommendedPlaces()
        }
    }
    
    func searchPlaces(keyword: String) async {
        guard !keyword.isEmpty else {
            searchResults = nil
            return
        }
        
        do {
            let response: TourAPIResponse<PlaceDTO> = try await NetworkService.shared.fetch(
                "/searchKeyword1",
                parameters: [
                    "keyword": keyword,
                    "numOfRows": "\(pageSize)",
                    "pageNo": "1",
                    "arrange": "A"  // 제목순 정렬
                ]
            )
            
            let places = response.response.body.items.item.map { $0.toPlace }
            await MainActor.run {
                self.searchResults = places
            }
        } catch {
            await MainActor.run {
                self.error = error
                self.searchResults = nil
            }
        }
    }
    
    func fetchRecommendedPlaces() async {
        currentPage = 1
        await loadRecommendedPlaces()
    }
    
    func loadMoreRecommendedPlaces() async {
        guard !isLoading, hasMorePlaces else { return }
        currentPage += 1
        await loadRecommendedPlaces()
    }
    
    private func loadRecommendedPlaces() async {
        isLoading = true
        
        do {
            let response: TourAPIResponse<PlaceDTO> = try await NetworkService.shared.fetch(
                "/areaBasedList1",
                parameters: [
                    "numOfRows": "\(pageSize)",
                    "pageNo": "\(currentPage)",
                    "arrange": "P",  // 인기순
                    "contentTypeId": "12"  // 관광지
                ]
            )
            
            let newPlaces = response.response.body.items.item.map { $0.toPlace }
            
            await MainActor.run {
                if self.recommendedPlaces == nil {
                    self.recommendedPlaces = newPlaces
                } else {
                    self.recommendedPlaces?.append(contentsOf: newPlaces)
                }
                
                self.hasMorePlaces = response.response.body.totalCount > (self.currentPage * self.pageSize)
            }
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
        
        isLoading = false
    }
}
