import Foundation
import SwiftUI

struct MemoRow: View {
    let memo: Memo
    @State private var image: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(memo.content)
                .font(.body)
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .cornerRadius(8)
            }
            
            Text(memo.createdAt.formatted(date: .numeric, time: .shortened))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
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
