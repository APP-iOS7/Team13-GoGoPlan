import SwiftUI
import Foundation

// 앱의 전역변수
class AppState: ObservableObject {
    static let shared = AppState() // 싱글톤 인스턴스
    
    @Published var selectedTab: Int = 0
    
    private init() {} // 싱글톤을 위한 private 생성자
}
