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
        
        // 로고 이미지를 표시할 UIImageView
        let logoImageView = UIImageView()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // 로고 이미지 설정
            logoImageView.image = UIImage(named: "Image") // "Image"라는 이름의 이미지를 로드
            logoImageView.contentMode = .scaleAspectFit // 이미지 비율 유지
            logoImageView.frame = CGRect(x: (view.frame.width - 100) / 2, y: (view.frame.height - 100) / 2, width: 100, height: 100) // 위치 및 크기 설정
            
            // contentView에 로고 추가
            if let contentView = self.view {
                contentView.addSubview(logoImageView) // 로고 이미지 뷰를 화면에 추가
            }
            
            // 애니메이션 시작
            startBurningAnimation() // 불타는 애니메이션 시작
        }
        
        // 불타는 애니메이션을 시작하는 메서드
        func startBurningAnimation() {
            // 불타는 효과를 위한 애니메이션 설정
            let burnAnimation = CAKeyframeAnimation(keyPath: "opacity") // 불타는 효과를 위한 키프레임 애니메이션
            burnAnimation.values = [1.0, 0.5, 0.0] // 불타는 효과의 투명도 변화
            burnAnimation.keyTimes = [0.0, 0.5, 1.0] // 애니메이션의 시간 비율
            burnAnimation.duration = 1.0 // 애니메이션 지속 시간
            
            // 크기 줄어드는 애니메이션
            UIView.animate(withDuration: 1.0, animations: {
                self.logoImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1) // 크기를 10%로 줄임
            }) { _ in
                // 애니메이션 완료 후 로고 제거
                self.logoImageView.layer.removeAllAnimations() // 모든 애니메이션 제거
                self.logoImageView.removeFromSuperview() // 로고 이미지 뷰를 화면에서 제거
            }
            
            // 애니메이션 추가
            logoImageView.layer.add(burnAnimation, forKey: "burnAnimation") // 불타는 애니메이션 추가
        }
    }
    
    var body: some View {
        NavigationStack {
            if showLogoScreen { // 로고 화면이 표시되는 경우
                LogoView()
                    .onAppear {
                        // 5초 후에 메인 화면으로 전환
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                showLogoScreen = false // 로고 화면 숨김
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
                                Text("오늘의 추천 여행지") // 추천 여행지 제목
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
                        Image(systemName: "house.fill") // 홈 아이콘
                        Text("홈") // 홈 탭 제목
                    }
                    .tag(0)
                    
                    // 나의 일정 탭
                    PlanListView()
                        .tabItem {
                            Image(systemName: "calendar") // 일정 아이콘
                            Text("나의 일정") // 일정 탭 제목
                        }
                        .tag(1)
                    
                    // 즐겨찾기 탭
                    LikePlaceView()
                        .tabItem {
                            Image(systemName: "heart.fill") // 즐겨찾기 아이콘
                            Text("즐겨찾기") // 즐겨찾기 탭 제목
                        }
                        .tag(2)
                }
                .navigationDestination(isPresented: $navigateToAddPlan) {
                    AddPlanView(onComplete: {
                        navigateToAddPlan = false // 일정 추가 후 '나의 일정' 탭으로 이동
                        selectedTab = 1
                        appState.selectedTab = 1
                    })
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView(authService: authService) // 설정 화면
                }
                .environmentObject(placeService) // 하위 뷰에서 공유 가능하도록 설정
            }
        }
    }
    
    // 상단 헤더 뷰
    private var headerView: some View {
        HStack {
            // 사용자 이름 및 설정 버튼
            Button(action: { showSettings = true }) {
                Text("안녕하세요, \(authService.currentUser?.name ?? "")님") // 사용자 이름 표시
                    .font(.headline)
            }
            
            Spacer() // 공간을 추가하여 버튼을 양쪽으로 배치
            
            // 일정 추가 버튼
            Button(action: {
                navigateToAddPlan = true // 일정 추가 화면으로 이동
            }) {
                Text("일정만들기") // 일정 추가 버튼 텍스트
                    .font(.headline)
                    .foregroundColor(.white) // 텍스트 색상
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue) // 배경색 설정
                    .cornerRadius(8) // 모서리 둥글게
            }
        }
        .padding() // 패딩 추가
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
}
    // 프리뷰
    #Preview {
        let authService = AuthService() // 가짜 인증 서비스 인스턴스
        
        ContentView(authService: authService)
            .environmentObject(AppState.shared) // 환경 객체 설정
    }

