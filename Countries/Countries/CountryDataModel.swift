
// CountryDataModel.swift

import Foundation

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

struct Currency: Codable {
    let code, name: String
    let symbol: String?
}

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
