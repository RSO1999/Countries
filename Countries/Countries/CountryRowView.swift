
//CountryRowView.swift
import SwiftUI

struct CountryRowView: View {
    let country: Country
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(country.name), \(country.region.rawValue)")
                    .font(.headline)
                Spacer()
                Text(country.code)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(country.capital)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}
