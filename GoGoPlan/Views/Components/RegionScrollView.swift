//
//  RegionScrollView.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//

import SwiftUI

struct RegionScrollView: View {
    @Binding var selectedRegion: String
    let regions: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(regions, id: \.self) { region in
                    Button(region) {
                        selectedRegion = region
                    }
                    .padding()
                    .background(selectedRegion == region ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}
