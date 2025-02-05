import Foundation
import SwiftUI

@MainActor
class PlaceService: ObservableObject {
    // 추천 여행지 목록
    @Published var recommendedPlaces: [Place]?
    // 검색 결과 목록
    @Published var searchResults: [Place]?
    // API 요청 중 발생한 오류
    @Published var error: Error?
    // 추가 데이터를 불러올 수 있는지 여부
    @Published var hasMorePlaces = false
    
    private var currentPage = 1 // 현재 페이지 번호
    private let pageSize = 20 // 한 번에 가져올 데이터 개수
    private var isLoading = false // 데이터 로딩 중 여부
    
    public init() {
        // 객체가 생성될 때 추천 여행지를 가져옴
        Task {
            await fetchRecommendedPlaces()
        }
    }
    
    // 키워드로 여행지 검색
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
    
    // 추천 여행지 데이터 초기화 후 가져오기
    func fetchRecommendedPlaces() async {
        currentPage = 1
        await loadRecommendedPlaces()
    }
    
    // 추가 추천 여행지 로드 (무한 스크롤 시 사용)
    func loadMoreRecommendedPlaces() async {
        guard !isLoading, hasMorePlaces else { return }
        currentPage += 1
        await loadRecommendedPlaces()
    }
    
    // API 호출을 통해 추천 여행지 데이터를 가져오는 함수
    private func loadRecommendedPlaces() async {
        isLoading = true
        
        do {
            let response: TourAPIResponse<PlaceDTO> = try await NetworkService.shared.fetch(
                "/areaBasedList1",
                parameters: [
                    "numOfRows": "\(pageSize)",
                    "pageNo": "\(currentPage)",
                    "arrange": "P",  // 인기순 정렬
                    "contentTypeId": "12"  // 관광지 유형
                ]
            )
            
            let newPlaces = response.response.body.items.item.map { $0.toPlace }
            
            await MainActor.run {
                if self.recommendedPlaces == nil {
                    self.recommendedPlaces = newPlaces
                } else {
                    self.recommendedPlaces?.append(contentsOf: newPlaces)
                }
                
                // 불러온 데이터 개수를 기반으로 추가 데이터 여부 결정
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
