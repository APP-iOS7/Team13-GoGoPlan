import UIKit
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Google 클라이언트 ID 설정
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: "994241928912-ssg6qosk1q5h5vobk00r0lllosrq26ls.apps.googleusercontent.com")
        return true
    }
    
    func application(_ app: UIApplication,
                    open url: URL,
                    options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
