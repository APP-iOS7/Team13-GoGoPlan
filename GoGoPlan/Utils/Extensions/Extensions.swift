import UIKit

// 로그인, 알림, 권한 요청 등 앱의 어느 화면에서든 표시해야 하는 UI를 보여줄 때 자주 사용
// 여기선 구글 로그인
// UIViewController 클래스를 확장하여 새로운 기능을 추가
extension UIViewController {
    // 현재 화면에 표시되는 최상위 UIViewController를 반환하는 정적 메서드
    static func topViewController() -> UIViewController? {
        // 현재 활성화된 키 윈도우(Key Window)를 찾는 과정
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }    // 현재 foreground에서 활성화된 scene만 필터링
            .map { $0 as? UIWindowScene }     // Scene을 UIWindowScene으로 타입 캐스팅
            .compactMap { $0 }    // nil이 아닌 값만 추출
            .first?               // 첫 번째 windowScene을 가져옴
            .windows              // windowScene의 모든 window 배열에서
            .filter { $0.isKeyWindow }.first    // 키 윈도우인 것만 필터링하여 첫 번째 것을 가져옴
        
        // 찾은 키 윈도우의 rootViewController를 반환
        // 키 윈도우가 없는 경우 nil 반환
        return keyWindow?.rootViewController
    }
}
