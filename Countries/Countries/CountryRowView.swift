
import SwiftUI



struct CountryRowView: View {
    let country: Country
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Top line: "name, region" on left, "code" on right
            HStack {
                Text("\(country.name), \(country.region.rawValue)")
                    .font(.headline)
                Spacer()
                Text(country.code)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Bottom line: capital
            Text(country.capital)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}
