//
//  PlaceService.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//
/*
import Foundation

protocol PlaceServiceProtocol {
    func fetchRecommendedPlaces() async throws -> [Place]
    func searchPlaces(query: String, region: String) async throws -> [Place]
}
*/


/*
import Foundation
import SwiftUI

@MainActor
class PlaceService: ObservableObject {
    @Published var recommendedPlaces: [Place]?
    @Published var error: Error?
    
    func fetchRecommendedPlaces() async {
        // TODO: API 구현
        // 임시 데이터
        recommendedPlaces = [
            Place(id: "1", name: "남산타워", address: "서울특별시 용산구", imageUrl: nil),
            Place(id: "2", name: "경복궁", address: "서울특별시 종로구", imageUrl: nil),
            Place(id: "3", name: "롯데월드", address: "서울특별시 송파구", imageUrl: nil)
        ]
    }
}
*/
/*
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
 
 func searchPlaces(keyword: String) async {
 guard !keyword.isEmpty else {
 searchResults = nil
 return
 }
 
 // TODO: 실제 API 호출 구현
 // 임시 검색 결과
 searchResults = [
 Place(name: "\(keyword) 관광지1",
 address: "서울특별시 용산구",
 latitude: 37.5511,
 longitude: 126.9882),
 Place(name: "\(keyword) 관광지2",
 address: "서울특별시 종로구",
 latitude: 37.5796,
 longitude: 126.9770)
 ]
 }
 
 func fetchRecommendedPlaces() async {
 guard recommendedPlaces == nil else { return }
 
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
 
 // TODO: 실제 API 호출 구현
 // 임시 데이터
 let newPlaces = [
 Place(name: "추천장소\(currentPage)-1",
 address: "서울특별시 용산구",
 latitude: 37.5511,
 longitude: 126.9882),
 Place(name: "추천장소\(currentPage)-2",
 address: "서울특별시 종로구",
 latitude: 37.5796,
 longitude: 126.9770)
 ]
 
 if recommendedPlaces == nil {
 recommendedPlaces = newPlaces
 } else {
 recommendedPlaces?.append(contentsOf: newPlaces)
 }
 
 // 더 불러올 데이터가 있는지 여부 (임시로 5페이지까지만)
 hasMorePlaces = currentPage < 5
 isLoading = false
 }
 }
 */

/*
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
                    "pageNo": "1"
                ]
            )
            
            searchResults = response.response.body.items.item.map { $0.toPlace }
        } catch {
            self.error = error
            searchResults = nil
        }
    }
    
    func fetchRecommendedPlaces() async {
        guard recommendedPlaces == nil else { return }
        
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
                    "arrange": "P"  // 인기순
                ]
            )
            
            let newPlaces = response.response.body.items.item.map { $0.toPlace }
            
            if recommendedPlaces == nil {
                recommendedPlaces = newPlaces
            } else {
                recommendedPlaces?.append(contentsOf: newPlaces)
            }
            
            hasMorePlaces = response.response.body.totalCount > currentPage * pageSize
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}
*/

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
    
    // 싱글톤 인스턴스
    static let shared = PlaceService()
    
    private init() {
        // 초기화 시 추천 장소 로드
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
            // 임시 데이터 사용 (나중에 실제 API로 교체)
            searchResults = [
                Place(name: "\(keyword) 관광지1",
                      address: "서울시 종로구",
                      latitude: 37.5665,
                      longitude: 126.9780),
                Place(name: "\(keyword) 관광지2",
                      address: "서울시 중구",
                      latitude: 37.5635,
                      longitude: 126.9975)
            ]
            
            // API 구현 후 사용할 코드
            /*
            let response: TourAPIResponse<PlaceDTO> = try await NetworkService.shared.fetch(
                "/searchKeyword1",
                parameters: [
                    "keyword": keyword,
                    "numOfRows": "\(pageSize)",
                    "pageNo": "1"
                ]
            )
            searchResults = response.response.body.items.item.map { $0.toPlace }
            */
        } catch {
            self.error = error
            searchResults = nil
        }
    }
    
    func fetchRecommendedPlaces() async {
        guard recommendedPlaces == nil else { return }
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
        
        // 임시 데이터 사용
        let newPlaces = [
            Place(name: "추천장소\(currentPage)-1",
                  address: "서울시 종로구",
                  latitude: 37.5665,
                  longitude: 126.9780),
            Place(name: "추천장소\(currentPage)-2",
                  address: "서울시 중구",
                  latitude: 37.5635,
                  longitude: 126.9975)
        ]
        
        if recommendedPlaces == nil {
            recommendedPlaces = newPlaces
        } else {
            recommendedPlaces?.append(contentsOf: newPlaces)
        }
        
        hasMorePlaces = currentPage < 5  // 임시로 5페이지까지만
        isLoading = false
    }
}
