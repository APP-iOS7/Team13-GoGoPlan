import SwiftUI
import SwiftData
import PhotosUI

// 메모를 추가할 때 보여줄 뷰
struct MemoView: View {
    // 메모 뷰를 닫기 위한 dismiss
    @Environment(\.dismiss) private var dismiss
    // swiftdata의 데이터를 가져올 modelContext
    @Environment(\.modelContext) private var modelContext
    // 메모의 내용
    @State private var content = ""
    // 메모의 선택된 이미지
    @State private var selectedImage: UIImage?
    //
    @State private var showImagePicker = false
    // 어디서 이미지를 가져올지 -> 사용자의 기기에 있는 이미지를 가져오자!
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    // 이미지 추가를 눌렀을 때 이미지를 어떻게 가져올지의 뷰를 보여줄지 유무 -> (ex. 이미지 선택 카메라 / 갤러리)
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
                
                // 선택된 이미지가 없다면 이미지를 어디서 가져올지 선택하는 뷰를 띄운다.
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
                    // 취소 버튼 클릭시 나의 일정 화면으로 돌아간다.
                    Button("취소") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.primary)
                    .cornerRadius(8)
                    
                    // 저장버튼 클릭시 메모가 저장되고 나의 일정 화면으로 돌아간다.
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
            // 갤러리 버튼을 클릭하게 되면 사용자 기기에서 이미지를 고를 ImagePicker 뷰를 보여준다.
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: imageSourceType)
            }
            // 선택된 이미지가 없다면 이미지를 어디서 가져올지 선택하는 뷰를 띄운다.
            .confirmationDialog("이미지 선택", isPresented: $showImageSourceActionSheet, titleVisibility: .visible) {
                // 카메라 버튼 -> 카메라로 찍어서 메모에 추가한다.
                // 카메라 사용을 못해서 실행 불가...
                Button("카메라") {
                    imageSourceType = .camera
                    showImagePicker = true
                }
                // 갤러리 버튼 -> 사용자 기기의 갤러리에서 가져온다.
                Button("갤러리") {
                    imageSourceType = .photoLibrary
                    showImagePicker = true
                }
                Button("취소", role: .cancel) {}
            }
        }
    }
    
    // 메모 저장
    private func saveMemo() {
        // 이미지 url
        var imageUrl: String?
        // 이미지가 있으면 저장
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
