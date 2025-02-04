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
import SwiftUI
import SwiftData
import GoogleSignIn

@main
struct GoGoPlanApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
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
                .environmentObject(AuthService())
        }
        .modelContainer(sharedModelContainer)
    }
}
