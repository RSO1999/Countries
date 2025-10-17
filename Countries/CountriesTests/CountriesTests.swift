//
//  CountriesTests.swift
//  CountriesTests
//
//  Created by Ryan Ortiz on 10/15/25.
//

import XCTest
@testable import Countries
import Foundation

final class CountriesTests: XCTestCase {
    
     @MainActor
     func testMockServiceReturnsCountries() async throws {
         let mockService = MockCountriesService()
         let testCountry1 = createTestCountry(name: "United States", code: "US", capital: "Washington, D.C.", region: .na)
         let testCountry2 = createTestCountry(name: "Canada", code: "CA", capital: "Ottawa", region: .na)
         mockService.countriesToReturn = [testCountry1, testCountry2]
         
         let result = try await mockService.fetchCountries()
         
         XCTAssertEqual(result.count, 2)
         XCTAssertEqual(result[0].name, "United States")
         XCTAssertEqual(result[1].name, "Canada")
     }

     @MainActor
     func testMockServiceThrowsError() async throws {
         // Arrange
         let mockService = MockCountriesService()
         mockService.shouldThrowError = .decodingFailed
         
         // Act & Assert
         do {
             _ = try await mockService.fetchCountries()
             XCTFail("Expected decodingFailed error but none was thrown")
         } catch {
             let networkError = error
             XCTAssertEqual(networkError, .decodingFailed)
         }
     }
    
    @MainActor
    func testViewModelUpdatesCountriesOnSuccess() async throws {
        let mockService = MockCountriesService()
        let testCountry = createTestCountry(name: "United States", code: "US", capital: "Washington, D.C.", region: .na)
        mockService.countriesToReturn = [testCountry]
        let viewModel = ExploreCountriesViewModel(countriesService: mockService)
        
        await viewModel.fetchCountries()
        
        XCTAssertEqual(viewModel.countries.count, 1)
        XCTAssertEqual(viewModel.countries[0].name, "United States")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    
    
    
    @MainActor
    func testViewModelSetsErrorMessageOnFailure() async throws {
        let mockService = MockCountriesService()
        mockService.shouldThrowError = .requestTimeout
        let viewModel = ExploreCountriesViewModel(countriesService: mockService)
        
        await viewModel.fetchCountries()
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.errorMessage?.contains("timed out") ?? false)
        XCTAssertTrue(viewModel.countries.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testViewModelHandlesEmptyCountriesArray() async throws {
        let mockService = MockCountriesService()
        mockService.countriesToReturn = [] // Empty array
        let viewModel = ExploreCountriesViewModel(countriesService: mockService)
        
        await viewModel.fetchCountries()
        
        XCTAssertTrue(viewModel.countries.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    
       @MainActor
       func testViewModelClearsErrorOnRetry() async throws {
        
           let mockService = MockCountriesService()
           mockService.shouldThrowError = .requestTimeout
           let viewModel = ExploreCountriesViewModel(countriesService: mockService)
           
           await viewModel.fetchCountries()
           XCTAssertNotNil(viewModel.errorMessage)
           
           mockService.shouldThrowError = nil
           let testCountry = createTestCountry(name: "United States", code: "US", region: .na)
           mockService.countriesToReturn = [testCountry]
           await viewModel.fetchCountries()
           
           XCTAssertNil(viewModel.errorMessage)
           XCTAssertEqual(viewModel.countries.count, 1)
       }


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
