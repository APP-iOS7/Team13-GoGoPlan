import SwiftUI

// 일정 추가하는 화면에서 스크롤해서 여행지를 선택하는 뷰
struct RegionScrollView: View {
    @Binding var selectedRegion: String
    let regions = ["서울", "경기", "인천", "강원", "충북", "충남", "대전", "세종", "경북", "경남", "대구", "울산", "부산", "전북", "전남", "광주", "제주"]
    
    var body: some View {
        // 가로 스크롤
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(regions, id: \.self) { region in
                    // 버튼 눌렀을 때 파란색으로 버튼 색이 변경됨.
                    Button(action: {
                        selectedRegion = region
                    }) {
                        Text(region)
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                selectedRegion == region ?
                                Color.blue :
                                Color.gray.opacity(0.2)
                            )
                            .foregroundColor(
                                selectedRegion == region ?
                                .white :
                                .primary
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    RegionScrollView(selectedRegion: .constant("서울"))
}
