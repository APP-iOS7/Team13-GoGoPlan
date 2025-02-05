//
//  ContentView.swift
//  GoGoPlan
//
//  Created by mwpark on 2/4/25.
//
/*
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
*/
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showSettings = false
    @State private var navigateToAddPlan = false
    @ObservedObject var authService: AuthService
    @StateObject private var placeService = PlaceService()
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                // 추천 여행지 탭
                VStack {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            Text("오늘의 추천 여행지")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            RecommendedPlaces(placeService: placeService)
                        }
                        .padding(.top)
                    }
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("추천")
                }
                .tag(0)
                
                // 나의 일정 탭
                PlanListView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("나의 일정")
                    }
                    .tag(1)
                
                // 즐겨찾기 탭
                LikePlaceView()
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("즐겨찾기")
                    }
                    .tag(2)
            }
            .navigationDestination(isPresented: $navigateToAddPlan) {
                AddPlanView(onComplete: {
                    navigateToAddPlan = false
                    selectedTab = 1
                })
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(authService: authService)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { showSettings = true }) {
                Text("안녕하세요, \(authService.currentUser?.name ?? "")님")
                    .font(.headline)
            }
            
            Spacer()
            
            Button(action: {
                navigateToAddPlan = true
            }) {
                Text("일정만들기")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(authService: AuthService())
}
