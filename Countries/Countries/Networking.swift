
// Networking.swift

import Foundation

// MARK: - 1. Typed Throws Protocol Signature
protocol CountriesService: Sendable {
    // Guarantees only NetworkError can be thrown from this function
    func fetchCountries() async throws(NetworkError) -> [Country]
}

// MARK: - 2. Concrete Implementation with Minimal Error Transformation
final class DefaultCountriesService: CountriesService {
    
    private let session: URLSession
    private let urlString = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
    
    // Custom init for testing, defaulting to .shared (Minimal Over-engineering)
    
    init(session: URLSession? = nil) {
        if let customSession = session {
            // Use injected session (for testing)
            self.session = customSession
        } else {
            // FIX: Create a custom configuration to explicitly disable the disk/memory cache.
            // This ensures a failure when launched in airplane mode.
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            configuration.timeoutIntervalForRequest = 30.0 // Good practice for robustness
            
            self.session = URLSession(configuration: configuration)
        }
    }
    // MARK: - 3. Implementation of Typed Throws (Fixes applied)
    func fetchCountries() async throws(NetworkError) -> [Country] {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response): (Data, URLResponse)
        
        do {
            // URLSession.data(from:) might throw URLError
            (data, response) = try await session.data(from: url)
        } catch let urlError as URLError {
            // Handle specific URLError codes
            if urlError.code == .timedOut {
                throw NetworkError.requestTimeout
            }
            // All other URLError codes (connectivity, etc.) map to invalidResponse
            throw NetworkError.invalidResponse
        } catch {
            // FIX 1: Catches any other generic Error thrown by the system/URLSession.
            // This satisfies the "throws(NetworkError)" requirement.
            throw NetworkError.invalidResponse
        }
        
        // Handle HTTP Response Check
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse // Not an HTTP response (unlikely but safe)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            // Map HTTP status code to custom server error
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        // Decode the data
        let decoder = JSONDecoder()
        
        do {
            // JSONDecoder.decode() might throw DecodingError
            return try decoder.decode([Country].self, from: data)
        } catch is DecodingError {
            // Map DecodingError to our custom decodingFailed error
            throw NetworkError.decodingFailed
        } catch {
            // FIX 2: Catches any other generic Error thrown by JSONDecoder (highly unlikely,
            // but required by Typed Throws) and maps it to a NetworkError.
            throw NetworkError.decodingFailed
        }
    }
}
