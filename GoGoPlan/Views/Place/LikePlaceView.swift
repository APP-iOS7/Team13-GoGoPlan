import SwiftUI
import SwiftData

struct LikePlaceView: View {
    @Query(filter: #Predicate<Place> { place in
        place.isFavorite == true
    }) private var favoritePlaces: [Place]
    
    var body: some View {
        NavigationView {
            if favoritePlaces.isEmpty {
                ContentUnavailableView(
                    "즐겨찾기한 장소가 없습니다",
                    systemImage: "heart",
                    description: Text("여행지를 둘러보고 마음에 드는 장소를 즐겨찾기해보세요")
                )
            } else {
                List {
                    ForEach(favoritePlaces) { place in
                        NavigationLink {
                            PlaceDetailView(place: place)
                        } label: {
                            PlaceLikeRow(place: place)
                        }
                    }
                }
                .navigationTitle("즐겨찾기")
            }
        }
    }
}

struct PlaceLikeRow: View {
    let place: Place
    
    var body: some View {
        HStack(spacing: 12) {
            // 장소 이미지
            if let imageUrl = place.imageUrl {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // 장소 이름
                Text(place.name)
                    .font(.headline)
                
                // 주소
                Text(place.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                // 카테고리
                if let category = place.category {
                    Text(category)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LikePlaceView()
        .modelContainer(for: Place.self, inMemory: true)
}
