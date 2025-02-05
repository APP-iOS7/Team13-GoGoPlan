//
//  PlaceRowView.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

import SwiftUI

struct PlaceRow: View {
    let place: Place
    let isEditing: Bool
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            // 이미지 추가
            if let imageUrl = place.imageUrl {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.headline)
                Text(place.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if isEditing {
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.red)
                }
            }
        }
    }
}
