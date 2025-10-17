

// ContentView.swift


import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ExploreCountriesViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading Countries...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                ErrorView(errorMessage: error) {
                    Task {
                        await viewModel.fetchCountries()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // HERE

            } else if viewModel.countries.isEmpty {
                EmptyListView(action: {
                    Task {
                        await viewModel.fetchCountries()
                    }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity) // HERE

            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.countries) { country in
                            CountryRowView(country: country)
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await viewModel.fetchCountries()
        }
    }
}
