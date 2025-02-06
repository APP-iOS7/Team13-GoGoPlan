import SwiftUI
import Foundation

// 전역변수
class AppState: ObservableObject {
    // 싱글톤 인스턴스
    static let shared = AppState()
    
    // 탭뷰에서 탭을 눌렀을 때 차례대로 0 1 2로 변함. -> 두번째 페이지에서만 toolbar가 뜨기 위함.
    @Published var selectedTab: Int = 0
    
    // 싱글톤을 위한 private 생성자
    private init() {}
}
