import SwiftUI
import PhotosUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    // 선택된 이미지를 바인딩하는 변수
    @Binding var selectedImage: UIImage?
    // 이미지 피커의 소스 타입 (카메라, 사진 라이브러리 등)
    let sourceType: UIImagePickerController.SourceType
    
    // UIViewController를 생성하는 메서드
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController() // UIImagePickerController 인스턴스 생성
        picker.delegate = context.coordinator // 델리게이트 설정
        picker.sourceType = sourceType // 소스 타입 설정
        return picker // 생성된 피커 반환
    }
    
    // UIViewController를 업데이트하는 메서드 (현재는 구현하지 않음)
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    // Coordinator를 생성하는 메서드
    func makeCoordinator() -> Coordinator {
        Coordinator(self) // 현재 ImagePicker 인스턴스를 전달하여 Coordinator 생성
    }
    
    // Coordinator 클래스 정의
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        // 부모 ImagePicker 인스턴스
        let parent: ImagePicker
        
        // 초기화 메서드
        init(_ parent: ImagePicker) {
            self.parent = parent // 부모 인스턴스 저장
        }
        
        // 이미지 선택 후 호출되는 메서드
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // 선택된 이미지가 있는 경우
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image // 선택된 이미지를 부모에 전달
            }
            picker.dismiss(animated: true) // 피커 닫기
        }
        
        // 이미지 선택이 취소되었을 때 호출되는 메서드
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) // 피커 닫기
        }
    }
}
