import SwiftUI
import GoogleSignIn

struct LoginView: View {    // AuthView -> LoginView로 이름 변경
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 15) {
                Button {
                    Task {
                        await authService.signInWithGoogle()
                    }
                } label: {
                    HStack {
                        Image(systemName: "g.circle.fill")
                            .foregroundColor(.red)
                        Text("구글로 계속하기")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
                
                Button {
                    authService.continueWithoutLogin()
                } label: {
                    Text("둘러보기")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .background(Color(.systemBackground))
    }
}
