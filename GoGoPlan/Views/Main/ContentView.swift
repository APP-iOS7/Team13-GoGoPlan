//
//  ContentView.swift
//  GoGoPlan
//
//  Created by mwpark on 2/4/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var authService = AuthService()
    @State private var showingSettings = false  // 추가
    
    var body: some View {
        Group {
            if authService.currentUser != nil {
                NavigationSplitView {
                    Text("메인 화면")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: { showingSettings = true }) {
                                Image(systemName: "gearshape")
                            }
                        }
                    }
                } detail: {
                    Text("Select an item")
                }
                .sheet(isPresented: $showingSettings) {
                    SettingsView()
                        .environmentObject(authService)
                }
            } else {
                LoginView()
                    .environmentObject(authService)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
