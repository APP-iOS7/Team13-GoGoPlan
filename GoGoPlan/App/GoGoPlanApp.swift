import SwiftUI
import SwiftData
import GoogleSignIn
import Foundation

@main
struct GoGoPlanApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @StateObject private var authService = AuthService()
    @StateObject private var appState = AppState.shared
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Memo.self,
            Place.self,
            Plan.self,
            User.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    // iampeel. 변경
    var body: some Scene {
        WindowGroup {
            if authService.currentUser != nil {
                ContentView(authService: authService)
                    .environmentObject(authService)
                    .environmentObject(appState)
            } else {
                AuthView()
                    .environmentObject(authService)
                    .environmentObject(appState)
            }

        }
        .modelContainer(sharedModelContainer)
    } //end
}

