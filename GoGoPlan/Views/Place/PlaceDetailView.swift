//
//  PlaceDetailView.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//
/*
import SwiftUI

struct PlaceDetailView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    PlaceDetailView()
}
*/

import SwiftUI
import SwiftData
import MapKit

struct PlaceDetailView: View {
    @Bindable var place: Place
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 이미지
                if let imageUrl = place.imageUrl {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 250)
                    .clipped()
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    // 장소 이름 및 즐겨찾기 버튼
                    HStack {
                        Text(place.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button {
                            place.isFavorite.toggle()
                        } label: {
                            Image(systemName: place.isFavorite ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(place.isFavorite ? .red : .gray)
                        }
                    }
                    
                    // 주소
                    VStack(alignment: .leading, spacing: 8) {
                        Label {
                            Text(place.address)
                                .fixedSize(horizontal: false, vertical: true)
                        } icon: {
                            Image(systemName: "mappin.circle.fill")
                        }
                        .foregroundColor(.gray)
                    }
                    
                    // 카테고리
                    if let category = place.category {
                        VStack(alignment: .leading, spacing: 8) {
                            Label {
                                Text(category)
                            } icon: {
                                Image(systemName: "tag.fill")
                            }
                            .foregroundColor(.gray)
                        }
                    }
                    
                    // 지도
                    Map(initialPosition: .region(MKCoordinateRegion(
                        center: place.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))) {
                        Marker(place.name, coordinate: place.coordinate)
                    }
                    .frame(height: 200)
                    .cornerRadius(12)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        PlaceDetailView(place: Place(
            name: "서울타워",
            address: "서울특별시 용산구 남산공원길 105",
            imageUrl: nil,
            latitude: 37.5511,
            longitude: 126.9882,
            category: "관광지"
        ))
    }
}
