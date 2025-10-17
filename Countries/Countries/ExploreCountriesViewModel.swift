
// ExploreCountriesViewModel.swift

import Foundation
import Combine

class ExploreCountriesViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let countriesService: CountriesService
    
    init(countriesService: CountriesService = DefaultCountriesService()) {
        self.countriesService = countriesService
    }
    
    @MainActor
    func fetchCountries() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Directly call the async service
            let fetchedCountries = try await countriesService.fetchCountries()
            
            self.countries = fetchedCountries
            self.isLoading = false
            
        } catch {
            // Caught error from the service
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}
