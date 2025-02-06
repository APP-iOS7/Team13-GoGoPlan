import SwiftUI

struct RecommendedPlaces: View {
    @EnvironmentObject var placeService: PlaceService  // 장소 데이터를 관리하는 서비스
    @State private var currentPage = 1  // 현재 불러온 페이지 번호
    @State private var isLoading = false  // 데이터를 불러오는 중인지 여부
    @State private var hasMorePlaces = true  // 추가로 불러올 장소가 있는지 여부
    @State private var showLoadingMessage = false  // 로딩 메시지 표시 여부
    
    // 이미지가 있는 장소만 필터링하여 가져옴
    private var filteredPlaces: [Place] {
        return (placeService.recommendedPlaces ?? [])
            .filter { $0.imageUrl != nil && !$0.imageUrl!.isEmpty }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {  // 세로 스크롤 지원, 스크롤바 숨김
            LazyVStack(spacing: 16) {  // 성능 최적화를 위한 LazyVStack 사용
                
                // 필터링된 장소 리스트를 표시
                ForEach(filteredPlaces, id: \ .id) { place in
                    NavigationLink(destination: PlaceDetailView(place: place)) {
                        PlaceCard(place: place)  // 장소 카드 뷰
                    }
                }
                
                // 스크롤이 끝까지 도달하면 새로운 장소 로드
                Color.clear
                    .frame(height: 20) // 여유 공간 추가
                    .onAppear {
                        if !isLoading && hasMorePlaces {
                            loadMorePlaces()  // 다음 페이지 불러오기
                        }
                    }
                
                // ✅ 더 이상 불러올 장소가 없을 때 메시지 표시
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
            .padding(.horizontal)  // 좌우 여백 추가
        }
        .task {
            await initialLoad()  // 화면이 로드되면 초기 데이터 불러오기
        }
    }
    
    // ✅ 첫 번째 페이지의 장소 데이터를 불러오는 함수
    private func initialLoad() async {
        isLoading = true  // 로딩 상태 활성화
        do {
            try await placeService.fetchRecommendedPlaces(page: 1)  // 첫 번째 페이지 불러오기
            currentPage = 1  // 현재 페이지를 1로 설정
            isLoading = false  // 로딩 완료
        } catch {
            print("Initial load error: \(error)")  // 오류 발생 시 출력
            isLoading = false  // 로딩 중지
        }
    }
    
    // ✅ 추가 장소 데이터를 불러오는 함수 (페이지네이션 처리)
    private func loadMorePlaces() {
        Task {
            isLoading = true  // 로딩 상태 활성화
            do {
                let nextPage = currentPage + 1  // 다음 페이지 계산
                let newPlaces = try await placeService.fetchRecommendedPlaces(page: nextPage)
                
                if newPlaces.isEmpty {
                    hasMorePlaces = false  // 추가 데이터가 없으면 더 이상 로드하지 않음
                } else {
                    currentPage = nextPage  // 현재 페이지 번호 업데이트
                }
                
                isLoading = false  // 로딩 완료
            } catch {
                print("Load more places error: \(error)")  // 오류 발생 시 출력
                isLoading = false  // 로딩 중지
            }
        }
    }
}

// ✅ 장소 정보를 카드 형태로 표시하는 뷰
struct PlaceCard: View {
    let place: Place  // 표시할 장소 정보
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageUrl = place.imageUrl {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray  // 로딩 중일 때 회색 배경 표시
                }
                .frame(height: 200)
                .clipped()
                .cornerRadius(12)
            }
            
            Text(place.name)  // 장소 이름
                .font(.headline)
                .lineLimit(1)
            
            Text(place.address)  // 장소 주소
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
        }
    }
}

// ✅ PlaceService 확장: 페이지네이션 지원
extension PlaceService {
    func fetchRecommendedPlaces(page: Int, pageSize: Int = 20) async throws -> [Place] {
        // 실제 API 호출 또는 데이터 로딩 로직 구현
        return []  // 예시로 빈 배열 반환 (실제 코드에서는 네트워크 요청 필요)
    }
}
