import SwiftUI
import MapKit

struct CustomMapView: View {
    let places: [Place]
    @State private var region: MKCoordinateRegion
    @State private var selectedPlace: Place?
    
    init(places: [Place]) {
        self.places = places
        // 초기 지도 중심을 서울로 설정
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: places) { place in
            MapAnnotation(coordinate: place.coordinate) {
                VStack {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    
                    if selectedPlace?.id == place.id {
                        Text(place.name)
                            .font(.caption)
                            .padding(4)
                            .background(Color.white)
                            .cornerRadius(4)
                            .shadow(radius: 2)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        selectedPlace = selectedPlace?.id == place.id ? nil : place
                    }
                }
            }
        }
        .onAppear {
            updateRegion()
        }
        .onChange(of: places) { _ in
            updateRegion()
        }
    }
    
    private func updateRegion() {
        guard !places.isEmpty else { return }
        
        // 모든 장소의 좌표를 포함하는 영역 계산
        let coordinates = places.map { $0.coordinate }
        let minLat = coordinates.map { $0.latitude }.min() ?? 0
        let maxLat = coordinates.map { $0.latitude }.max() ?? 0
        let minLon = coordinates.map { $0.longitude }.min() ?? 0
        let maxLon = coordinates.map { $0.longitude }.max() ?? 0
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        // 여유 공간을 위해 영역을 1.5배 확장
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5 + 0.01,
            longitudeDelta: (maxLon - minLon) * 1.5 + 0.01
        )
        
        withAnimation {
            region = MKCoordinateRegion(center: center, span: span)
        }
    }
}

#Preview {
    CustomMapView(places: [
        Place(name: "서울타워",
              address: "서울특별시 용산구",
              latitude: 37.5511,
              longitude: 126.9882),
        Place(name: "경복궁",
              address: "서울특별시 종로구",
              latitude: 37.5796,
              longitude: 126.9770)
    ])
}
