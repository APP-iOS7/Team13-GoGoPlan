import Foundation
import GoogleSignIn
import SwiftUI
import SwiftData

@MainActor
class AuthService: ObservableObject {
    @Published var currentUser: User?  // 현재 로그인된 사용자 정보를 저장하는 변수
    @Published var error: Error?      // 로그인 실패 시 오류를 저장하는 변수
    
    // 앱이 시작될 때 자동으로 로그인 상태를 확인하여, 이전에 로그인된 상태를 복원할 수 있음
    init() {
        // UserDefaults를 이용해 앱 시작 시 저장된 "isDevMode" 값 확인
        if UserDefaults.standard.bool(forKey: "isDevMode") {
            // 개발자 모드가 활성화된 경우, 가짜 사용자 정보로 로그인 처리 (개발자용 테스트)
            self.currentUser = User(
                id: "dev",              // 사용자 ID는 'dev'
                email: "dev@test.com",  // 이메일은 'dev@test.com'
                loginType: .google,     // 로그인 타입은 구글로 설정 (개발자 모드)
                name: "개발자",           // 이름은 '개발자'
                profileUrl: nil         // 프로필 이미지는 설정하지 않음
            )
        }
    }
    
    // 구글 로그인 함수: 사용자가 구글로 로그인하는 과정
    func signInWithGoogle() async {
        // 현재 활성화된 최상위 뷰컨트롤러를 가져옴. 구글 로그인 화면을 이 뷰컨트롤러 위에 띄움
        guard let topVC = UIViewController.topViewController() else { return }
        
        do {
            // 비동기적으로 구글 로그인 진행
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
            let user = result.user  // 로그인한 사용자의 정보를 가져옴
            let email = user.profile?.email ?? "Unknown"  // 이메일이 없다면 "Unknown"으로 처리
            
            // 로그인 성공 후, currentUser에 사용자 정보를 저장
            self.currentUser = User(
                id: user.userID ?? UUID().uuidString,  // 사용자 ID가 없으면 새 UUID를 생성하여 사용
                email: email,                          // 사용자의 이메일 저장
                loginType: .google,                    // 로그인 타입은 구글로 설정
                name: user.profile?.name,              // 사용자 이름 (구글 프로필에서 가져옴)
                profileUrl: user.profile?.imageURL(withDimension: 100)?.absoluteString  // 프로필 이미지 URL (100px 크기로 설정)
            )
        } catch {
            // 로그인 실패 시 발생하는 오류를 error에 저장
            self.error = error
        }
    }
    
    // 로그아웃 함수: 사용자가 로그아웃할 때 호출
    func signOut() {
        // 현재 로그인된 사용자가 구글로 로그인한 상태라면, 구글 로그아웃을 처리
        if currentUser?.loginType == .google {
            GIDSignIn.sharedInstance.signOut()
        }
        // 로그인 상태를 해제하고, currentUser를 nil로 설정하여 로그아웃 처리
        currentUser = nil
    }
    
    // 로그인 없이 앱을 이용하고자 할 때 호출
    func continueWithoutLogin() {
        // '게스트' 사용자로 로그인 처리 (로그인 없이 앱을 사용하려는 경우)
        self.currentUser = User(
            id: UUID().uuidString,  // 새 UUID로 사용자 ID 생성
            email: "게스트",          // 이메일을 '게스트'로 설정
            loginType: .none,       // 로그인 타입은 '없음'
            name: nil,              // 이름은 설정하지 않음
            profileUrl: nil         // 프로필 이미지 URL은 없음
        )
    }
}


/* 구글 로그인 구현하려면 xcode에서
 Package Dependencies 추가:
 Xcode 메뉴 -> File -> Add Packages
 이거 검색창에 넣고 나오는 패키지 다운로드
 구글 로그인 https://github.com/google/GoogleSignIn-iOS
 카카오 로그인 https://github.com/kakao/kakao-ios-sdk
 네이버 로그인 https://github.com/naver/naveridlogin-sdk-ios
 애플 로그인 https://developer.apple.com/documentation/authenticationservices
 */

/* 구글 클라우드 콘솔에서
 사이트로 이동
 https://console.cloud.google.com/apis/dashboard?inv=1&invt=Abo0uQ&project=gogoplan
 왼쪽 목차에서 OAuth 동의 화면 만들기
 (사용자 유형: 외부) (그 외 특별히 설정할 건 없습니다)
 왼쪽 목차에서 사용자 인증 정보
 상단에 사용자 인증 정보 만들기
 하라는대로 하다보면 OAuth2.0클라이언트 ID가 생성됩니다.
 거기서 클라이언트 ID와 다운로드해서 보이는 번호들이 사용됩니다.
 또 정리해서 올려드릴께요
 */
