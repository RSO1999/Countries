
//
//  CountryDataModel.swift
//  Countries
//
//  Created by Ryan Ortiz on 10/15/25.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let countries = try? JSONDecoder().decode([Country].self, from: jsonData)

import Foundation

// MARK: - Country
struct Country: Codable, Identifiable {
    let capital, code: String
    let currency: Currency
    let flag: String
    let language: Language
    let name: String
    let region: Region
    let demonym: String?
    var id: String { "\(code)-\(name)" }

}

// MARK: - Currency
struct Currency: Codable {
    let code, name: String
    let symbol: String?
}

// MARK: - Language
struct Language: Codable {
    let code: String?
    let name: String
    let iso6392, nativeName: String?

    enum CodingKeys: String, CodingKey {
        case code, name
        case iso6392 = "iso639_2"
        case nativeName
    }
}

enum Region: String, Codable {
    case af = "AF"
    case americas = "Americas"
    case an = "AN"
    case empty = ""
    case eu = "EU"
    case na = "NA"
    case oc = "OC"
    case regionAS = "AS"
    case sa = "SA"
}
