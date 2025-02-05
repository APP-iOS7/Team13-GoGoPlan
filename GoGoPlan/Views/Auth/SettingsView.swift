import SwiftUI
import SwiftData

struct SettingsView: View {
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var authService: AuthService
    @AppStorage("isDevMode") private var isDevMode = false
    
    // 생성자 추가
    init(authService: AuthService) {
        self.authService = authService
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("계정") {
                    if let user = authService.currentUser {
                        if user.loginType == .none {
                            // 게스트일 때
                            Button {
                                Task {
                                    await authService.signInWithGoogle()
                                    if authService.error == nil {
                                        dismiss()
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "g.circle.fill")
                                        .foregroundColor(.red)
                                    Text("구글로 로그인")
                                }
                            }
                        } else {
                            // 로그인된 상태일 때
                            HStack {
                                Text("이메일")
                                Spacer()
                                Text(user.email)
                                    .foregroundColor(.gray)
                            }
                            
                            if let name = user.name {
                                HStack {
                                    Text("이름")
                                    Spacer()
                                    Text(name)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Button(role: .destructive) {
                                authService.signOut()
                                dismiss()
                            } label: {
                                Text("로그아웃")
                            }
                        }
                    }
                }
                
                // 개발자 모드는 로그인된 상태에서만 표시
                if authService.currentUser?.loginType == .google {
                    Section("개발자 옵션") {
                        Toggle("개발자 모드", isOn: $isDevMode)
                    }
                }
                
                // 탈퇴 버튼 (Google 로그인 상태일 때만 표시)
                if authService.currentUser?.loginType == .google {
                    Section {
                        Button(action: { showDeleteAlert = true }) {
                            Text("탈퇴하기")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Section("정보") {
                    HStack {
                        Text("버전")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("완료") {
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("계정 탈퇴"),
                    message: Text("정말로 탈퇴하시겠습니까?\n모든 데이터가 삭제됩니다."),
                    primaryButton: .destructive(Text("탈퇴하기")) {
                        // 탈퇴 로직 구현 필요
                        authService.signOut()
                        dismiss()
                    },
                    secondaryButton: .cancel(Text("취소"))
                )
            }
            .alert("로그인 실패", isPresented: .init(
                get: { authService.error != nil },
                set: { _ in authService.error = nil }
            )) {
                Button("확인", role: .cancel) {
                    authService.error = nil
                }
            } message: {
                Text(authService.error?.localizedDescription ?? "알 수 없는 오류가 발생했습니다.")
            }
        }
    }
}

#Preview {
    SettingsView(authService: AuthService())
}
