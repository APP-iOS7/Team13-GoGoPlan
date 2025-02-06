import Foundation

// 네트워크 관련 오류를 정의하는 열거형
// 오류가 발생했을 때 적절한 오류 메시지를 반환하기 위해 사용됨
enum NetworkError: Error {
    case invalidURL       // 잘못된 URL일 때 발생
    case invalidResponse  // 서버로부터 잘못된 응답을 받을 때 발생
    case noData           // 응답 데이터가 없을 때 발생
    case decodingError    // JSON 디코딩에 실패했을 때 발생
    case apiError(String) // API에서 오류 메시지를 반환할 때 발생 (오류 메시지 포함)
}

@MainActor // UI 업데이트를 메인 스레드에서 실행하도록 지정
class NetworkService {
    // 싱글톤 인스턴스 (앱 전역에서 하나의 인스턴스만 사용)
    static let shared = NetworkService()
    
    // API의 기본 URL
    private let baseURL = "http://apis.data.go.kr/B551011/KorService1"
    
    // API 키 (공공 데이터 포털에서 제공하는 인증 키)
    private let apiKey = "IsuLk83FxV9CRLW90v2p6Q8fPtXohm8NWl4n63CmkxX/3PdnTUQPjS0TB0EJv5AWYEQN7QYTYQIGLTkJzDL1Ow=="
    
    // 외부에서 인스턴스를 생성하지 못하도록 private init 사용
    private init() {}
    
    // 제네릭을 사용하여 다양한 데이터 타입을 처리할 수 있는 네트워크 요청 함수
    func fetch<T: Decodable>(_ endpoint: String, parameters: [String: String] = [:]) async throws -> T {
        
        // URLComponents를 사용하여 URL을 조립함
        var components = URLComponents(string: baseURL + endpoint)
        
        // 기본 요청 파라미터 설정 (API 호출 시 필수)
        var queryItems = [
            URLQueryItem(name: "serviceKey", value: apiKey), // API 키
            URLQueryItem(name: "MobileOS", value: "IOS"),   // 운영체제 정보
            URLQueryItem(name: "MobileApp", value: "GoGoPlan"), // 앱 이름
            URLQueryItem(name: "_type", value: "json") // 응답 타입 (JSON 형식)
        ]
        
        // 추가적인 파라미터가 있을 경우 URL에 포함시킴
        queryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        components?.queryItems = queryItems
        
        // 유효한 URL이 생성되었는지 확인
        guard let url = components?.url else {
            throw NetworkError.invalidURL // URL 생성 실패 시 오류 발생
        }
        
        print("Request URL: \(url)") // 디버깅을 위한 요청 URL 출력
        
        do {
            // 비동기 네트워크 요청 수행
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // 응답이 HTTPURLResponse 타입인지 확인
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response type")
                throw NetworkError.invalidResponse // 응답 타입이 잘못된 경우 오류 발생
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)") // 응답 상태 코드 출력
            
            // 서버로부터 받은 원본 JSON 데이터를 문자열로 출력 (디버깅용)
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw response: \(responseString)")
            }
            
            // HTTP 상태 코드가 200(성공)이 아닐 경우 오류 발생
            guard httpResponse.statusCode == 200 else {
                print("Error status code: \(httpResponse.statusCode)")
                throw NetworkError.apiError("Status code: \(httpResponse.statusCode)")
            }
            
            do {
                // JSONDecoder를 사용하여 데이터를 디코딩
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Decoding error: \(error)")
                throw NetworkError.decodingError // JSON 디코딩 오류 발생
            }
        } catch {
            print("Network error: \(error)")
            throw error // 네트워크 오류가 발생하면 그대로 전달
        }
    }
}




/* Info.plist 파일 내용입니다.
구글 로그인, api가져오기에 필요한 내용입니다.
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
 <dict>
     <!-- URL 스킴을 설정하여 특정 앱과 연동 -->
     <key>CFBundleURLTypes</key>
     <array>
         <dict>
             <!-- 앱의 URL 스킴 이름 -->
             <key>CFBundleURLName</key>
             <string>com.googleusercontent.apps.994241928912-ssg6qosk1q5h5vobk00r0lllosrq26ls</string>
             
             <!-- 앱에서 사용할 URL 스킴 (구글 로그인 등에 사용) -->
             <key>CFBundleURLSchemes</key>
             <array>
                 <string>com.googleusercontent.apps.994241928912-ssg6qosk1q5h5vobk00r0lllosrq26ls</string>
             </array>
         </dict>
     </array>

     <!-- 보안 관련 설정 (앱에서 외부 네트워크 요청 허용) -->
     <key>NSAppTransportSecurity</key>
     <dict>
         <!-- HTTP 요청을 모두 허용 (보안 설정 약화 가능성 있음) -->
         <key>NSAllowsArbitraryLoads</key>
         <true/>

         <!-- 특정 도메인(apis.data.go.kr)에 대해 HTTP 요청 예외 허용 -->
         <key>NSExceptionDomains</key>
         <dict>
             <key>apis.data.go.kr</key>
             <dict>
                 <!-- 해당 도메인에서 HTTP 통신을 허용 -->
                 <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
                 <true/>
             </dict>
         </dict>
     </dict>
 </dict>
 </plist>

 
 
 */
