import SwiftUI
import SwiftData

struct LikePlaceView: View {
    // 즐겨찾기한 장소를 쿼리하여 가져오는 프로퍼티
    @Query(filter: #Predicate<Place> { place in
        place.isFavorite == true // 즐겨찾기한 장소만 필터링
    }) private var favoritePlaces: [Place]
    
    var body: some View {
        NavigationView {
            // 즐겨찾기한 장소가 없는 경우
            if favoritePlaces.isEmpty {
                ContentUnavailableView(
                    "즐겨찾기한 장소가 없습니다", // 메시지
                    systemImage: "heart", // 시스템 이미지
                    description: Text("여행지를 둘러보고 마음에 드는 장소를 즐겨찾기해보세요") // 추가 설명
                )
            } else {
                // 즐겨찾기한 장소가 있는 경우
                List {
                    // 즐겨찾기한 장소 목록을 반복하여 표시
                    ForEach(favoritePlaces) { place in
                        NavigationLink {
                            // 장소 상세보기로 이동
                            PlaceDetailView(place: place)
                        } label: {
                            // 장소 정보를 표시하는 행
                            PlaceLikeRow(place: place)
                        }
                    }
                }
                .navigationTitle("즐겨찾기") // 내비게이션 타이틀 설정
            }
        }
    }
}

struct PlaceLikeRow: View {
    let place: Place // 장소 정보를 담는 프로퍼티
    
    var body: some View {
        HStack(spacing: 12) {
            // 장소 이미지
            if let imageUrl = place.imageUrl {
                // 비동기적으로 이미지를 로드
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable() // 이미지 크기 조정 가능
                        .aspectRatio(contentMode: .fill) // 비율 유지
                } placeholder: {
                    Color.gray // 이미지 로드 중에 표시할 색상
                }
                .frame(width: 80, height: 80) // 이미지 크기 설정
                .clipShape(RoundedRectangle(cornerRadius: 8)) // 둥근 모서리
            } else {
                // 이미지가 없는 경우 기본 UI 표시
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2)) // 배경색
                    .frame(width: 80, height: 80) // 크기 설정
                    .overlay {
                        Image(systemName: "photo") // 기본 이미지 아이콘
                            .foregroundColor(.gray) // 아이콘 색상
                    }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // 장소 이름
                Text(place.name)
                    .font(.headline) // 헤드라인 폰트
                
                // 주소
                Text(place.address)
                    .font(.subheadline) // 서브헤드라인 폰트
                    .foregroundColor(.gray) // 텍스트 색상
                    .lineLimit(1) // 한 줄로 제한
                
                // 카테고리
                if let category = place.category {
                    Text(category)
                        .font(.caption) // 캡션 폰트
                        .foregroundColor(.blue) // 텍스트 색상
                        .padding(.horizontal, 8) // 수평 패딩
                        .padding(.vertical, 4) // 수직 패딩
                        .background(Color.blue.opacity(0.1)) // 배경색
                        .cornerRadius(4) // 둥근 모서리
                }
            }
        }
        .padding(.vertical, 4) // 수직 패딩
    }
}

// 프리뷰
#Preview {
    LikePlaceView()
        .modelContainer(for: Place.self, inMemory: true) // 메모리 내 모델 컨테이너 설정
}
