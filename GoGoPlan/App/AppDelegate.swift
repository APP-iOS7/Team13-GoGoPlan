import UIKit
import GoogleSignIn

// AppDelegate 클래스: 앱의 주요 이벤트를 처리하는 역할
class AppDelegate: NSObject, UIApplicationDelegate {
    
    // 앱이 실행될 때 호출되는 메서드
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Google 로그인에 필요한 클라이언트 ID 설정
        // Google Cloud Console에서 생성한 OAuth 클라이언트 ID를 사용해야 함
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: "994241928912-ssg6qosk1q5h5vobk00r0lllosrq26ls.apps.googleusercontent.com"
        )
        
        return true // 앱 실행 완료
    }
    
    // Google 로그인 후 인증 URL을 처리하는 메서드
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        
        // Google 로그인 SDK에서 인증 URL을 처리하도록 전달
        return GIDSignIn.sharedInstance.handle(url)
    }
}
