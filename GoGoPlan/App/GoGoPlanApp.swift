/*
 GoogleSignIn import 추가
 AppDelegate 추가 (@UIApplicationDelegateAdaptor)
 AuthService를 environmentObject로 추가
 */
import Foundation
import SwiftUI
import SwiftData
import GoogleSignIn

@main
struct GoGoPlanApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Memo.self, Place.self, Plan.self, User.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthService())
        }
        .modelContainer(sharedModelContainer)
    }
}
