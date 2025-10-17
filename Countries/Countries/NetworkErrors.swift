
//
//  NetworkErrors.swift
//  Countries
//
//  Created by Ryan Ortiz on 10/16/25.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case serverError(Int)
    case requestTimeout

    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid server response"
        case .decodingFailed: return "Failed to parse data"
        case .serverError(let code): return "Server error: \(code)"
        case .requestTimeout: return "Request timed out"
        }
    }
}
