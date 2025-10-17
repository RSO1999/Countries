

// ContentView.swift

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ExploreCountriesViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.countries) { country in
                        CountryRowView(country: country)
                    }
                }
                .padding()
            }
        }
        .task {
            await viewModel.fetchCountries()
        }
    }
}
