import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0 // 현재 선택된 탭
    @State private var showSettings = false // 설정 화면 표시 여부
    @State private var navigateToAddPlan = false // 일정 추가 화면 이동 여부
    @ObservedObject var authService: AuthService // 사용자 인증 서비스
    @StateObject private var placeService = PlaceService() // 추천 여행지 서비스
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                // 추천 여행지 탭
                VStack {
                    headerView // 상단 헤더
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            Text("오늘의 추천 여행지")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            RecommendedPlaces() // 추천 여행지 목록 ✅ 그냥 이렇게 호출하면 됨!
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
                    selectedTab = 1 // 일정 추가 후 '나의 일정' 탭으로 이동
                })
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(authService: authService) // 설정 화면
            }
            .environmentObject(placeService)  // ✅ 하위 뷰에서 공유 가능하도록 설정
        }
    }
    
    // 상단 헤더 뷰
    private var headerView: some View {
        HStack {
            // 사용자 이름 및 설정 버튼
            Button(action: { showSettings = true }) {
                Text("안녕하세요, \(authService.currentUser?.name ?? "")님")
                    .font(.headline)
            }
            
            Spacer()
            
            // 일정 추가 버튼
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
