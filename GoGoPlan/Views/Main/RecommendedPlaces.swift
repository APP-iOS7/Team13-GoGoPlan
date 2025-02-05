import SwiftUI

struct RecommendedPlaces: View {
    @ObservedObject var placeService: PlaceService
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
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

#Preview {
    RecommendedPlaces(placeService: PlaceService())
}
