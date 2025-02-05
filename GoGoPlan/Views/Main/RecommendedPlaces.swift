import SwiftUI

struct RecommendedPlaces: View {
    @EnvironmentObject var placeService: PlaceService
    @State private var currentPage = 1
    @State private var isLoading = false
    @State private var hasMorePlaces = true
    @State private var showLoadingMessage = false  // 추가된 상태 변수
    
    // 이미지가 있는 장소만 필터링
    private var filteredPlaces: [Place] {
        return (placeService.recommendedPlaces ?? [])
            .filter { $0.imageUrl != nil && !$0.imageUrl!.isEmpty }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                // 이미지 있는 장소만 표시
                ForEach(filteredPlaces, id: \.id) { place in
                    NavigationLink(destination: PlaceDetailView(place: place)) {
                        PlaceCard(place: place)
                    }
                }
                
                // 스크롤의 마지막에 도달했을 때 다음 페이지 로드
                Color.clear
                    .frame(height: 20) // 조금 여유 공간 추가
                    .onAppear {
                        if !isLoading && hasMorePlaces {
                            loadMorePlaces()
                        }
                    }
                
                // ✅ 스크롤 맨 아래에 메시지 추가
                if !isLoading && !hasMorePlaces && !filteredPlaces.isEmpty {
                    VStack(spacing: 8) {
                        Text("오늘의 여행지는 여기까지!")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("새로운 여행지가 계속 업데이트됩니다 ✈️")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }

            }
            .padding(.horizontal)
        }

        .task {
            await initialLoad()
        }
    }
    
    // 초기 로드 함수
    private func initialLoad() async {
        isLoading = true
        do {
            try await placeService.fetchRecommendedPlaces(page: 1)
            currentPage = 1
            isLoading = false
        } catch {
            print("Initial load error: \(error)")
            isLoading = false
        }
    }
    
    // 추가 장소 로드 함수
    private func loadMorePlaces() {
        Task {
            isLoading = true
            do {
                let nextPage = currentPage + 1
                let newPlaces = try await placeService.fetchRecommendedPlaces(page: nextPage)
                
                // 더 이상 불러올 장소가 없으면 hasMorePlaces를 false로 설정
                if newPlaces.isEmpty {
                    hasMorePlaces = false
                } else {
                    currentPage = nextPage
                }
                
                isLoading = false
            } catch {
                print("Load more places error: \(error)")
                isLoading = false
            }
        }
    }
}

struct PlaceCard: View {
    let place: Place
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageUrl = place.imageUrl {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(height: 200)
                .clipped()
                .cornerRadius(12)
            }
            
            Text(place.name)
                .font(.headline)
                .lineLimit(1)
            
            Text(place.address)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
        }
    }
}

// PlaceService 확장: 페이지네이션 지원
extension PlaceService {
    func fetchRecommendedPlaces(page: Int, pageSize: Int = 20) async throws -> [Place] {
        // 여기에 실제 API 호출 또는 데이터 로딩 로직 구현
        // 예시로 빈 배열 반환, 실제로는 네트워크 요청 필요
        return []
    }
}
