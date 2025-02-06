import Foundation

// 네트워크 관련 오류 정의
enum NetworkError: Error {
    case invalidURL       // 잘못된 URL
    case invalidResponse  // 잘못된 응답
    case noData           // 데이터 없음
    case decodingError    // 디코딩 오류
    case apiError(String) // API 오류 메시지 포함
}

@MainActor
class NetworkService {
    static let shared = NetworkService() // 싱글톤 인스턴스
    
    private let baseURL = "http://apis.data.go.kr/B551011/KorService1" // 기본 API URL
    private let apiKey = "IsuLk83FxV9CRLW90v2p6Q8fPtXohm8NWl4n63CmkxX/3PdnTUQPjS0TB0EJv5AWYEQN7QYTYQIGLTkJzDL1Ow==" // API 키
    
    private init() {} // 외부에서 인스턴스 생성 방지
    
    // 제네릭을 활용한 네트워크 요청 함수
    func fetch<T: Decodable>(_ endpoint: String, parameters: [String: String] = [:]) async throws -> T {
        var components = URLComponents(string: baseURL + endpoint) // 요청 URL 생성
        
        // 기본 요청 파라미터 설정
        var queryItems = [
            URLQueryItem(name: "serviceKey", value: apiKey),
            URLQueryItem(name: "MobileOS", value: "IOS"),
            URLQueryItem(name: "MobileApp", value: "GoGoPlan"),
            URLQueryItem(name: "_type", value: "json")
        ]
        
        // 추가 파라미터 적용
        queryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL // URL 생성 실패 시 오류 발생
        }
        
        print("Request URL: \(url)") // 디버깅용 URL 출력
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url) // 네트워크 요청
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response type")
                throw NetworkError.invalidResponse // 응답 타입 오류
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw response: \(responseString)") // 응답 데이터 확인
            }
            
            guard httpResponse.statusCode == 200 else {
                print("Error status code: \(httpResponse.statusCode)")
                throw NetworkError.apiError("Status code: \(httpResponse.statusCode)") // HTTP 상태 코드 오류 처리
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data) // JSON 디코딩
            } catch {
                print("Decoding error: \(error)")
                throw NetworkError.decodingError // 디코딩 오류 처리
            }
        } catch {
            print("Network error: \(error)")
            throw error // 네트워크 오류 처리
        }
    }
}
