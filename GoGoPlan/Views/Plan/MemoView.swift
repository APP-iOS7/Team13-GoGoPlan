import SwiftUI
import SwiftData
import PhotosUI

struct MemoView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var content = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImageSourceActionSheet = false
    let day: Day
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // 메모 입력
                TextEditor(text: $content)
                    .frame(maxHeight: 200)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal)
                
                // 이미지 표시
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(8)
                        .overlay(
                            Button(action: { selectedImage = nil }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .shadow(radius: 2)
                            }
                            .padding(8),
                            alignment: .topTrailing
                        )
                        .padding(.horizontal)
                }
                
                // 이미지 추가 버튼
                if selectedImage == nil {
                    Button(action: { showImageSourceActionSheet = true }) {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                            Text("이미지 추가")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // 하단 버튼
                HStack {
                    Button("취소") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.primary)
                    .cornerRadius(8)
                    
                    Button("저장") {
                        saveMemo()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(content.isEmpty ? Color.gray.opacity(0.1) : Color.blue)
                    .foregroundColor(content.isEmpty ? .gray : .white)
                    .cornerRadius(8)
                    .disabled(content.isEmpty)
                }
                .padding()
            }
            .navigationTitle("메모 추가")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: imageSourceType)
            }
            .confirmationDialog("이미지 선택", isPresented: $showImageSourceActionSheet, titleVisibility: .visible) {
                Button("카메라") {
                    imageSourceType = .camera
                    showImagePicker = true
                }
                Button("갤러리") {
                    imageSourceType = .photoLibrary
                    showImagePicker = true
                }
                Button("취소", role: .cancel) {}
            }
        }
    }
    
    private func saveMemo() {
        // 이미지가 있으면 저장
        var imageUrl: String?
        if let image = selectedImage {
            imageUrl = ImageStorage.shared.saveImage(image)
        }
        
        // 메모 생성 및 저장
        let memo = Memo(
            content: content,
            imageUrl: imageUrl
        )
        
        day.memos.append(memo)
        
        dismiss()
    }
}

#Preview {
    let day = Day(date: Date(), dayNumber: 1)
    MemoView(day: day)
}
