import SwiftUI
import SwiftData
import GoogleSignIn
import Foundation

@main
struct GoGoPlanApp: App {
    // UIApplicationDelegateAdaptor를 사용하여 AppDelegate를 연결
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    // 인증 서비스와 앱 상태를 관리하기 위한 StateObject 생성
    @StateObject private var authService = AuthService()
    @StateObject private var appState = AppState.shared
    
    // 모델 컨테이너를 생성하는 클로저
    var sharedModelContainer: ModelContainer = {
        // 스키마 정의: Memo, Place, Plan, User 모델 포함
        let schema = Schema([
            Memo.self,
            Place.self,
            Plan.self,
            User.self
        ])
        // 모델 구성 설정: 메모리에만 저장하지 않도록 설정
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            // 모델 컨테이너 생성
            return try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            // 모델 컨테이너 생성 실패 시 에러 출력
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    // 앱의 메인 뷰를 정의하는 body 프로퍼티
    var body: some Scene {
        WindowGroup {
            // 현재 사용자가 인증된 경우 ContentView를 표시
            if authService.currentUser != nil {
                ContentView(authService: authService)
                    .environmentObject(authService) // authService를 환경 객체로 추가
                    .environmentObject(appState) // appState를 환경 객체로 추가
            } else {
                // 인증되지 않은 경우 AuthView를 표시
                AuthView()
                    .environmentObject(authService) // authService를 환경 객체로 추가
                    .environmentObject(appState) // appState를 환경 객체로 추가
            }
        }
        // 모델 컨테이너를 WindowGroup에 추가
        .modelContainer(sharedModelContainer)
    } //end
}

