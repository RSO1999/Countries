
import Foundation
import Observation

@Observable
class ExploreCountriesViewModel {
    var countries: [Country] = []
    var isLoading = false
    var errorMessage: String?
    
    @MainActor
    func fetchCountries() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedCountries = try await fetch()
                await MainActor.run {
                    self.countries = fetchedCountries
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
