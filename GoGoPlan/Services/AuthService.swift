import Foundation
import GoogleSignIn
import SwiftUI
import SwiftData

@MainActor
class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var error: Error?
    
    // 앱 시작시 자동 로그인되게
    init() {
        // 앱 시작시 저장된 로그인 상태 확인
        if UserDefaults.standard.bool(forKey: "isDevMode") {
            self.currentUser = User(
                id: "dev",
                email: "dev@test.com",
                loginType: .google,
                name: "개발자",
                profileUrl: nil
            )
        }
    }
    
    
    func signInWithGoogle() async {
        guard let topVC = UIViewController.topViewController() else { return }
        
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
            let user = result.user
            let email = user.profile?.email ?? "Unknown"
            
            // currentUser 설정
            self.currentUser = User(
                id: user.userID ?? UUID().uuidString,
                email: email,
                loginType: .google,
                name: user.profile?.name,
                profileUrl: user.profile?.imageURL(withDimension: 100)?.absoluteString
            )
        } catch {
            self.error = error
        }
    }
    
    func signOut() {
        if currentUser?.loginType == .google {
            GIDSignIn.sharedInstance.signOut()
        }
        currentUser = nil
    }
    
    // 둘러보기로 입장할 때
    func continueWithoutLogin() {
        self.currentUser = User(
            id: UUID().uuidString,
            email: "게스트",
            loginType: .none,
            name: nil,
            profileUrl: nil
        )
    }
}
