//
//  ErrorView.swift
//  Countries
//
//  Created by Ryan Ortiz on 10/16/25.
//

import Foundation
import SwiftUI



struct ErrorView: View {
    let errorMessage: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
            
            Text("Error Loading Data")
                .font(.headline)
            
            Text(errorMessage)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                retryAction()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

struct EmptyListView: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "globe")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
            
            Text("No Countries Found")
                .font(.headline)
            
            Text("The list appears to be empty.")
                .font(.subheadline)
            
            Button("Check Again") {
                action()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
