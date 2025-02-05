import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case apiError(String)
}

struct TourAPIResponse<T: Decodable>: Decodable {
    let response: Response<T>
}

struct Response<T: Decodable>: Decodable {
    let header: Header
    let body: Body<T>
}

struct Header: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct Body<T: Decodable>: Decodable {
    let items: Items<T>
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct Items<T: Decodable>: Decodable {
    let item: [T]
}

@MainActor
class NetworkService {
    static let shared = NetworkService()
    
    private let baseURL = "https://apis.data.go.kr/B551011/KorService1"
    private let apiKey: String = "" // TODO: API 키 입력 필요
    
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
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.apiError("Status code: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
}
