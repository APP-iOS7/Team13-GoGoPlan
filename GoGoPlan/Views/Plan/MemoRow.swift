import Foundation
import SwiftUI

// 메모 하나의 뷰
struct MemoRow: View {
    // 메모의 정보들을 담은 Memo 객체
    let memo: Memo
    // 메모안에 추가할 이미지
    @State private var image: UIImage?
    
    var body: some View {
        // 좌측 정렬
        VStack(alignment: .leading, spacing: 8) {
            // 메모의 내용
            Text(memo.content)
                .font(.body)
            
            // 이미지가 있다면 이미지 출력
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .cornerRadius(8)
            }
            
            // 메모가 만들어진 날짜 출력
            Text(memo.createdAt.formatted(date: .numeric, time: .shortened))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .onAppear {
            // 메모 뷰가 보이는 경우 메모에 추가한 이미지를 불러온다.
            loadImage()
        }
    }
    
    // 이미지를 불러온다.
    private func loadImage() {
        // 메모에 추가한 이미지의 url이 있는 경우(이미지가 있는 경우) -> ImageStorage 클래스의 loadImage함수를 통해 이미지를 추가한다.
        if let fileName = memo.imageUrl {
            image = ImageStorage.shared.loadImage(fileName: fileName)
        }
    }
}

#Preview {
    let memo = Memo(content: "테스트 메모입니다.", imageUrl: nil)
    return MemoRow(memo: memo)
        .padding()
        .background(Color.gray.opacity(0.1))
}
