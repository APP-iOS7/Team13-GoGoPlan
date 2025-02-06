import UIKit

class ImageStorage {
    // 싱글톤 인스턴스
    static let shared = ImageStorage()
    
    // 초기화 메서드 (private으로 설정하여 외부에서 인스턴스 생성 불가)
    private init() {}
    
    // 이미지를 저장하는 메서드
    func saveImage(_ image: UIImage) -> String? {
        // 이미지 압축 (JPEG 형식으로 변환)
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        
        // 저장할 파일 이름 생성 (UUID를 사용하여 고유한 이름 생성)
        let fileName = UUID().uuidString + ".jpg"
        // Documents 디렉토리의 파일 경로 생성
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            // 이미지 데이터를 파일에 저장
            try data.write(to: fileURL)
            return fileName // 저장된 파일 이름 반환
        } catch {
            print("Error saving image: \(error)") // 오류 발생 시 출력
            return nil // 저장 실패 시 nil 반환
        }
    }
    
    // 이미지를 로드하는 메서드
    func loadImage(fileName: String) -> UIImage? {
        // 파일 경로 생성
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            // 파일에서 데이터 읽기
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data) // UIImage로 변환하여 반환
        } catch {
            print("Error loading image: \(error)") // 오류 발생 시 출력
            return nil // 로드 실패 시 nil 반환
        }
    }
    
    // 이미지를 삭제하는 메서드
    func deleteImage(fileName: String) {
        // 파일 경로 생성
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            // 파일 삭제
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Error deleting image: \(error)") // 오류 발생 시 출력
        }
    }
    
    // Documents 디렉토리의 URL을 반환하는 메서드
    private func getDocumentsDirectory() -> URL {
        // 사용자 도메인 마스크의 Documents 디렉토리 경로 반환
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
