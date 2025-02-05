import SwiftUI

struct RecommendedPlaces: View {
    @EnvironmentObject var placeService: PlaceService
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) { // 세로 스크롤로 변경
            LazyVStack(spacing: 16) { // HStack을 VStack으로 변경
                ForEach(placeService.recommendedPlaces ?? [], id: \.id) { place in
                    PlaceCard(place: place)
                }
            }
            .padding(.horizontal)
        }
        .task {
            await placeService.fetchRecommendedPlaces()
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
                .frame(height: 200) // width 제한을 제거하고 height만 지정
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
        // width 280 제한을 제거하여 화면 너비에 맞춤
    }
}
