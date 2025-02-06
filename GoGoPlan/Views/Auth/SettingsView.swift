import SwiftUI

struct SettingsView: View {
    // 탈퇴 확인 알림을 표시할지 여부를 저장하는 변수
    @State private var showDeleteAlert = false

    // 현재 뷰를 닫기 위한 SwiftUI 환경 변수
    @Environment(\.dismiss) var dismiss

    // 로그인 및 인증을 관리하는 객체 (ObservedObject로 상태 감지)
    @ObservedObject private var authService: AuthService

    // 개발자 모드 설정을 저장하는 변수 (앱 저장소에서 관리)
    @AppStorage("isDevMode") private var isDevMode = false

    // 로그아웃 후 로그인 화면으로 이동할지 여부를 결정하는 변수
    @State private var shouldNavigateToLogin = false

    // 초기화 메서드: 인증 객체를 전달받아 설정
    init(authService: AuthService) {
        self.authService = authService
    }
    
    var body: some View {
        NavigationView {
            List {
                // 계정 관련 설정 섹션
                Section("계정") {
                    if let user = authService.currentUser {
                        // 로그인되지 않은 경우 (익명 사용자)
                        if user.loginType == .none {
                            Button {
                                Task {
                                    await authService.signInWithGoogle()  // 구글 로그인 실행
                                    if authService.error == nil {
                                        dismiss()  // 로그인 성공 시 설정 화면 닫기
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "g.circle.fill")  // 구글 로그인 아이콘
                                        .foregroundColor(.red)
                                    Text("구글로 로그인")  // 로그인 버튼 텍스트
                                }
                            }
                        } else {
                            // 이미 로그인된 경우 사용자 정보 표시
                            HStack {
                                Text("이메일")  // 이메일 레이블
                                Spacer()
                                Text(user.email)  // 사용자 이메일 표시
                                    .foregroundColor(.gray)
                            }
                            
                            // 사용자의 이름이 있는 경우 표시
                            if let name = user.name {
                                HStack {
                                    Text("이름")  // 이름 레이블
                                    Spacer()
                                    Text(name)  // 사용자 이름 표시
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            // 로그아웃 버튼
                            Button(role: .destructive) {
                                authService.signOut()  // 로그아웃 실행
                                shouldNavigateToLogin = true  // 로그인 화면으로 이동 설정
                            } label: {
                                Text("로그아웃")  // 로그아웃 버튼 텍스트
                            }
                        }
                    }
                }
                
                // 구글 로그인한 사용자만 개발자 모드 설정 가능
                if authService.currentUser?.loginType == .google {
                    Section("개발자 옵션") {
                        Toggle("개발자 모드", isOn: $isDevMode)  // 개발자 모드 ON/OFF
                    }
                }
                
                // 구글 로그인한 사용자만 탈퇴 버튼 표시
                if authService.currentUser?.loginType == .google {
                    Section {
                        Button(action: { showDeleteAlert = true }) {
                            Text("탈퇴하기")  // 탈퇴 버튼 텍스트
                                .foregroundColor(.red)  // 경고 색상
                        }
                    }
                }
                
                // 앱 정보 섹션
                Section("정보") {
                    HStack {
                        Text("버전")  // 버전 레이블
                        Spacer()
                        Text("1.0.0")  // 앱 버전 정보
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("설정")  // 네비게이션 타이틀 설정
            .navigationBarTitleDisplayMode(.inline)  // 상단 타이틀을 중앙에 배치
            .toolbar {
                // 상단 완료 버튼
                ToolbarItem(placement: .topBarTrailing) {
                    Button("완료") {
                        dismiss()  // 설정 화면 닫기
                    }
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                // 탈퇴 확인 알림창
                Alert(
                    title: Text("계정 탈퇴"),
                    message: Text("정말로 탈퇴하시겠습니까?\n모든 데이터가 삭제됩니다."),
                    primaryButton: .destructive(Text("탈퇴하기")) {
                        authService.signOut()  // 계정 탈퇴 후 로그아웃 처리
                        shouldNavigateToLogin = true  // 로그인 화면으로 이동
                    },
                    secondaryButton: .cancel(Text("취소"))  // 취소 버튼
                )
            }
            .alert("로그인 실패", isPresented: .init(
                get: { authService.error != nil },  // 로그인 오류 감지
                set: { _ in authService.error = nil }  // 오류 발생 시 초기화
            )) {
                Button("확인", role: .cancel) {
                    authService.error = nil  // 오류 메시지 초기화
                }
            } message: {
                Text(authService.error?.localizedDescription ?? "알 수 없는 오류가 발생했습니다.")  // 오류 상세 메시지
            }
            
            // 로그아웃 상태일 때 로그인 화면으로 이동
            NavigationLink(
                destination: AuthView(),  // 이동할 로그인 화면
                isActive: $shouldNavigateToLogin,  // 상태 변수를 통해 이동 제어
                label: { EmptyView() }  // 화면에는 아무것도 표시하지 않음
            )
        }
    }
}
