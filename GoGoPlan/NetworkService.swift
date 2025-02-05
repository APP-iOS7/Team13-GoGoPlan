import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case apiError(String)
}

@MainActor
class NetworkService {
    static let shared = NetworkService()
    
    private let baseURL = "http://apis.data.go.kr/B551011/KorService1"
    private let apiKey = "IsuLk83FxV9CRLW90v2p6Q8fPtXohm8NWl4n63CmkxX/3PdnTUQPjS0TB0EJv5AWYEQN7QYTYQIGLTkJzDL1Ow=="
    
    private init() {}
    
    func fetch<T: Decodable>(_ endpoint: String, parameters: [String: String] = [:]) async throws -> T {
        var components = URLComponents(string: baseURL + endpoint)
        
        // 기본 파라미터 설정
        var queryItems = [
            URLQueryItem(name: "serviceKey", value: apiKey),
            URLQueryItem(name: "MobileOS", value: "IOS"),
            URLQueryItem(name: "MobileApp", value: "GoGoPlan"),
            URLQueryItem(name: "_type", value: "json")
        ]
        
        // 추가 파라미터 설정
        queryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        print("Request URL: \(url)")  // URL 디버깅용
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response type")
                throw NetworkError.invalidResponse
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw response: \(responseString)")
            }
            
            guard httpResponse.statusCode == 200 else {
                print("Error status code: \(httpResponse.statusCode)")
                throw NetworkError.apiError("Status code: \(httpResponse.statusCode)")
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Decoding error: \(error)")
                throw NetworkError.decodingError
            }
        } catch {
            print("Network error: \(error)")
            throw error
        }
    }
}
