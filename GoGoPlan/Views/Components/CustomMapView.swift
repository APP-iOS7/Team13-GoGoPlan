import SwiftUI
import MapKit

struct CustomMapView: View {
    // 지도에 표시할 장소들
    let places: [Place]
    // 장소의 지역 정보(위도, 경도 등)
    @State private var region: MKCoordinateRegion
    // 장소들 중 선택된 장소
    @State private var selectedPlace: Place?
    
    // 초기화 함수
    init(places: [Place]) {
        self.places = places
        // 초기 지도 중심을 서울로 설정
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }
    
    var body: some View {
        // MapKit사용
        Map(coordinateRegion: $region, annotationItems: places) { place in
            MapAnnotation(coordinate: place.coordinate) {
                VStack {
                    ZStack {
                        // 지도에 표시될 핀의 기본 원 모양
                        Circle()
                            .fill(.white)
                            .frame(width: 30, height: 30)
                        
                        // 핀 아이콘 (빨간색)
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    
                    // 선택된 장소에 대해 이름을 표시
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
                        // 장소를 탭하면 선택/선택 해제
                        selectedPlace = selectedPlace?.id == place.id ? nil : place
                    }
                }
            }
        }
        // 뷰가 나타날 때마다 지역 갱신
        .onAppear {
            updateRegion()
        }
        // 장소 목록이 변경될 때마다 지역 갱신
        .onChange(of: places) { _ in
            updateRegion()
        }
    }
    
    // 장소들에 맞춰서 지도 영역을 갱신하는 함수
    private func updateRegion() {
        guard !places.isEmpty else { return }
        
        // 모든 장소의 좌표를 포함하는 영역 계산
        let coordinates = places.map { $0.coordinate }
        let minLat = coordinates.map { $0.latitude }.min() ?? 0
        let maxLat = coordinates.map { $0.latitude }.max() ?? 0
        let minLon = coordinates.map { $0.longitude }.min() ?? 0
        let maxLon = coordinates.map { $0.longitude }.max() ?? 0
        
        // 계산된 최소/최대 위도, 경도를 바탕으로 중심 좌표 설정
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        // 여유 공간을 위해 영역을 1.5배 확장 (보기 편하게)
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5 + 0.01,
            longitudeDelta: (maxLon - minLon) * 1.5 + 0.01
        )
        
        withAnimation {
            // 계산된 중심과 영역을 바탕으로 지도 영역 갱신
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
