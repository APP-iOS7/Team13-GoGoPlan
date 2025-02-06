// Foundation과 SwiftData 프레임워크를 import
import Foundation
import SwiftData

// 로그인 타입을 정의하는 열거형
// String 타입으로 인코딩/디코딩 가능하도록 Codable 프로토콜 채택
enum LoginType: String, Codable {
   case google    // 구글 로그인
   case none      // 둘러보기용 (로그인하지 않은 상태)
}

// SwiftData로 데이터를 저장하기 위한 Model 클래스
@Model  // SwiftData의 Model 매크로를 사용하여 persistence 지원
class User {
   var id: String             // 사용자의 고유 식별자
   var email: String          // 사용자의 이메일 주소
   var loginType: LoginType   // 사용자의 로그인 방식 (google 또는 none)
   var name: String?          // 사용자의 이름 (옵셔널)
   var profileUrl: String?    // 사용자의 프로필 이미지 URL (옵셔널)
   
   // 초기화 메서드
   // 기본값을 제공하여 필요한 속성만 설정할 수 있도록 함
   init(
       id: String = UUID().uuidString,     // 기본값으로 랜덤 UUID 생성
       email: String = "",                 // 기본값으로 빈 문자열
       loginType: LoginType = .none,       // 기본값으로 둘러보기 모드
       name: String? = nil,                // 기본값으로 nil
       profileUrl: String? = nil           // 기본값으로 nil
   ) {
       self.id = id
       self.email = email
       self.loginType = loginType
       self.name = name
       self.profileUrl = profileUrl
   }
}
