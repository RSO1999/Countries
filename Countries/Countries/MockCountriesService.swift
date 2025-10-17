////
//  MockCountriesService.swift
//  Countries
//
//  Created by Ryan Ortiz on 10/16/25.
//

import Foundation
@testable import Countries

final class MockCountriesService: CountriesService, @unchecked Sendable {
    nonisolated(unsafe) var shouldThrowError: NetworkError?
    nonisolated(unsafe) var countriesToReturn: [Country] = []
    
    func fetchCountries() async throws(NetworkError) -> [Country] {
        if let error = shouldThrowError {
            throw error
        }
        return countriesToReturn
    }
}

func createTestCountry(
    name: String = "Test Country",
    code: String = "TC",
    capital: String = "Test Capital",
    region: Region = .empty
) -> Country {
    Country(
        capital: capital,
        code: code,
        currency: Currency(code: "USD", name: "US Dollar", symbol: "$"),
        flag: "https://example.com/flag.svg",
        language: Language(code: "en", name: "English", iso6392: "eng", nativeName: "English"),
        name: name,
        region: region,
        demonym: nil
    )
}
