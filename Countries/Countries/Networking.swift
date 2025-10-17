
// Networking.swift
import Foundation
func fetch() async throws -> [Country]{
    let urlString = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
    guard let url = URL(string: urlString) else {
        throw NetworkError.invalidURL
    }
    
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    // 3. Handle the response (e.g., check status code)
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }
    
    // 4. Decode the data
    let decoder = JSONDecoder()
    let decodedData = try decoder.decode([Country].self, from: data)
    
    print("Decoded", decodedData)
    
    return decodedData
    
}
