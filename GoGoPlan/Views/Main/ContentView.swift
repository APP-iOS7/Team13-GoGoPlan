import SwiftUI
import SwiftData
import UIKit 
struct ContentView: View {
    @State private var selectedTab = 0 // 현재 선택된 탭
    @State private var showSettings = false // 설정 화면 표시 여부
    @State private var navigateToAddPlan = false // 일정 추가 화면 이동 여부
    @ObservedObject var authService: AuthService // 사용자 인증 서비스
    @StateObject private var placeService = PlaceService() // 추천 여행지 서비스
    @State private var showLogoScreen = true // 로고 화면 표시 여부
    @EnvironmentObject private var appState: AppState
    class ViewController: UIViewController {
        
        let logoImageView = UIImageView()

        override func viewDidLoad() {
            super.viewDidLoad()
            
            // 로고 이미지 설정
            logoImageView.image = UIImage(named: "Image")
            logoImageView.contentMode = .scaleAspectFit
            logoImageView.frame = CGRect(x: (view.frame.width - 100) / 2, y: (view.frame.height - 100) / 2, width: 100, height: 100)
            
            // contentView에 로고 추가
            if let contentView = self.view {
                contentView.addSubview(logoImageView)
            }
            
            // 애니메이션 시작
            startBurningAnimation()
        }
        
        func startBurningAnimation() {
            // 불타는 효과를 위한 애니메이션
            let burnAnimation = CAKeyframeAnimation(keyPath: "opacity")
            burnAnimation.values = [1.0, 0.5, 0.0]
            burnAnimation.keyTimes = [0.0, 0.5, 1.0]
            burnAnimation.duration = 1.0
            
            // 크기 줄어드는 애니메이션
            UIView.animate(withDuration: 1.0, animations: {
                self.logoImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { _ in
                // 애니메이션 완료 후 로고 제거
                self.logoImageView.layer.removeAllAnimations()
                self.logoImageView.removeFromSuperview()
            }
            
            // 애니메이션 추가
            logoImageView.layer.add(burnAnimation, forKey: "burnAnimation")
        }
    }
    var body: some View {
        NavigationStack {
            if showLogoScreen {// 로고 화면
                LogoView()
                    .onAppear {
                        // 2초 후에 메인 화면으로 전환
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                showLogoScreen = false
                            }
                        }
                    }
            } else {
                // 메인 화면
                TabView(selection: $appState.selectedTab) {
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
                                
                                RecommendedPlaces() // 추천 여행지 목록
                            }
                            .padding(.top)
                        }
                        .padding(.bottom, 10)
                    }
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("홈")
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
                        appState.selectedTab = 1
                    })
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView(authService: authService) // 설정 화면
                }
                .environmentObject(placeService)  // 하위 뷰에서 공유 가능하도록 설정
            }
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
// 로고 화면 뷰
struct LogoView: View {
    var body: some View {
        VStack {
            Image("Image") // 로고 이미지 이름
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 500) // 로고 크기 조정
        }
        .background(Color.white) // 배경색
        .edgesIgnoringSafeArea(.all) // 안전 영역 무시
    }
}
    // 프리뷰
    #Preview {
        let authService = AuthService() // 가짜 인증 서비스 인스턴스
        
        ContentView(authService: authService)
            .environmentObject(AppState.shared)
    }

