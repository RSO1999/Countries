

import SwiftUI

struct ContentView: View {
    private let viewModel = ExploreCountriesViewModel()
    
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
            viewModel.fetchCountries()
        }
    }
}
