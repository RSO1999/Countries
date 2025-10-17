
// Networking.swift

import Foundation

protocol CountriesService: Sendable {
    func fetchCountries() async throws(NetworkError) -> [Country]
}

// MARK: - 2. Concrete Implementation with Minimal Error Transformation
final class DefaultCountriesService: CountriesService {
    
    private let session: URLSession
    private let urlString = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
    
    
    init(session: URLSession? = nil) {
        if let customSession = session {
            self.session = customSession
        } else {

            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            configuration.timeoutIntervalForRequest = 30.0
            
            self.session = URLSession(configuration: configuration)
        }
    }
    func fetchCountries() async throws(NetworkError) -> [Country] {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await session.data(from: url)
        } catch let urlError as URLError {
            if urlError.code == .timedOut {
                throw NetworkError.requestTimeout
            }
            throw NetworkError.invalidResponse
        } catch {

            throw NetworkError.invalidResponse
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode([Country].self, from: data)
        } catch is DecodingError {
            throw NetworkError.decodingFailed
        } catch {
           
            throw NetworkError.decodingFailed
        }
    }
}
