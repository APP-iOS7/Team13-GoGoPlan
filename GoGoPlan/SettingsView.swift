import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss
    
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
                                    dismiss()
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
                            
                            Button(role: .destructive) {
                                authService.signOut()
                                dismiss()
                            } label: {
                                Text("로그아웃")
                            }
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
        }
    }
}
