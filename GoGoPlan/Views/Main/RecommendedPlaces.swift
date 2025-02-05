import SwiftUI

struct RecommendedPlaces: View {
    @EnvironmentObject var placeService: PlaceService  // ✅ 부모에서 자동으로 받음
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) { // 가로 스크롤 가능한 목록
            LazyHStack(spacing: 16) {
                ForEach(placeService.recommendedPlaces ?? [], id: \.id) { place in
                    PlaceCard(place: place) // 개별 장소 카드
                }
            }
            .padding(.horizontal)
        }
        .task {
            await placeService.fetchRecommendedPlaces() // 데이터 가져오기
        }
    }
}

struct PlaceCard: View {
    let place: Place // 여행지 정보
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageUrl = place.imageUrl {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray // 로딩 중 회색 배경 표시
                }
                .frame(width: 280, height: 200)
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
        .frame(width: 280)
    }
}

