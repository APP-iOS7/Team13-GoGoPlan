import SwiftUI
import GoogleSignIn

struct AuthView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // 상단 Spacer는 화면의 상단 여백을 확보합니다.
                Spacer()
                
                VStack(spacing: 30) {
                    Text("로그인과 회원가입을 한 번에!\n언제든 탈퇴도 가능합니다.")
                        .font(.headline)  // 글자 크기 설정
                        .fontWeight(.medium)  // 글자 굵기 설정
                        .foregroundColor(.white)  // 글자 색을 흰색으로 설정
                        .multilineTextAlignment(.center)  // 텍스트를 중앙 정렬
                        .padding()  // 텍스트에 여백 추가
                        .background(LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing))  // 배경에 그라디언트 색상 추가
                        .cornerRadius(10)  // 모서리 둥글게 처리
                        .shadow(radius: 5)  // 그림자 효과 추가
                        .frame(maxWidth: .infinity)  // 가로 너비 최대값을 설정하여 가운데 정렬
                    
                    VStack(spacing: 15) {
                        // 구글 로그인 버튼
                        Button {
                            Task {
                                await authService.signInWithGoogle()  // 구글로 로그인 요청
                            }
                        } label: {
                            HStack {
                                Image(systemName: "g.circle.fill")  // 구글 아이콘
                                    .foregroundColor(.white)  // 아이콘 색상 흰색으로 설정
                                Text("구글로 계속하기")
                                    .fontWeight(.semibold)  // 글자 굵기 설정
                                    .foregroundColor(.white)  // 텍스트 색상 흰색으로 설정
                            }
                            .frame(maxWidth: .infinity)  // 가로 너비 최대값을 설정하여 가운데 정렬
                            .padding()  // 버튼에 여백 추가
                            // RGB 값으로 색 지정 (0~255 범위를 0~1로 나눔)
                            .background(Color(red: 50/255, green: 150/255, blue: 243/255))
                            .cornerRadius(8)  // 모서리 둥글게 처리
                            .shadow(radius: 3)  // 그림자 효과 추가
                        }
                        
                        // 둘러보기 버튼
                        Button {
                            authService.continueWithoutLogin()  // 로그인 없이 둘러보기 기능 실행
                        } label: {
                            Text("둘러보기")
                                .fontWeight(.semibold)  // 글자 굵기 설정
                                .foregroundColor(.white)  // 텍스트 색상 흰색으로 설정
                                .padding()  // 버튼에 여백 추가
                                .background(Color(red: 33/255, green: 150/255, blue: 243/255))
                                .cornerRadius(8)  // 모서리 둥글게 처리
                                .shadow(radius: 3)  // 그림자 효과 추가
                        }
                    }
                    .padding(.horizontal, 30)  // 버튼들 양 옆에 여백 추가
                    .frame(maxWidth: .infinity)  // 가로 너비 최대값을 설정하여 가운데 정렬
                }
                
                // 하단 Spacer는 화면의 하단 여백을 확보합니다.
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)  // 화면 중앙에 배치
            .background(Color(.systemBackground))  // 배경 색상 설정
        }
    }
}
