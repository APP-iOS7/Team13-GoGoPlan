//
//  GoGoPlanApp.swift
//  GoGoPlan
//
//  Created by mwpark on 2/4/25.
//
/*
import SwiftUI
import SwiftData

@main
struct GoGoPlanApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
        }
        .modelContainer(sharedModelContainer)
    }
}
*/


/*
 GoogleSignIn import 추가
 AppDelegate 추가 (@UIApplicationDelegateAdaptor)
 AuthService를 environmentObject로 추가
 */

/*
import SwiftUI
import SwiftData
import GoogleSignIn
import Foundation

@main
struct GoGoPlanApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthService())
        }
        .modelContainer(sharedModelContainer)
    }
}
*/

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

    var body: some Scene {
        WindowGroup {
            ContentView(authService: authService)
                .environmentObject(authService)
                .environmentObject(appState)
        }
        .modelContainer(sharedModelContainer)
    }
}

// 앱의 전역변수
class AppState: ObservableObject {
    static let shared = AppState() // 싱글톤 인스턴스
    
    @Published var selectedTab: Int = 0
    
    private init() {} // 싱글톤을 위한 private 생성자
}
