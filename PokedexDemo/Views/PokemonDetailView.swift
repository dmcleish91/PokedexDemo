//
//  PokemonDetailView.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/8/25.
//

/**
 * POKEMON DETAIL VIEW
 * 
 * Displays detailed information for a selected Pokemon. Demonstrates async
 * data loading, local state management, and error handling patterns in SwiftUI.
 * 
 * Data Flow: Receives Pokemon → Loads details via ViewModel → Displays data
 * Pattern: Local loading state + shared data cache
 */

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    
    // SHARED STATE: ViewModel passed from parent view
    // Maintains shared cache while allowing local state management
    @ObservedObject var viewModel: PokemonViewModel
    
    // LOCAL STATE: Detail-specific loading and error states
    // Provides immediate feedback while maintaining shared data
    @State private var isLoadingDetails = false
    @State private var detailsError: String?
    
    // COMPUTED PROPERTY: Access cached detail data
    // Demonstrates safe dictionary access patterns
    private var pokemonDetails: DetailPokemon? {
        viewModel.pokemonDetails[pokemon.pokemonId]
    }
    
    var body: some View {
        VStack {
            // COMPONENT REUSE: Same Pokemon view used in list and detail
            PokemonView(pokemon: pokemon)
            
            // CONDITIONAL UI: Different states based on data availability
            Group {
                if isLoadingDetails {
                    ProgressView("Loading details...")
                        .frame(height: 100)
                } else if let details = pokemonDetails {
                    detailsView(details)
                } else if let error = detailsError {
                    // ERROR HANDLING UI: Graceful error display with retry
                    VStack {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await loadPokemonDetails()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    Text("No details available")
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .navigationTitle(pokemon.name.capitalized)
        .navigationBarTitleDisplayMode(.large)
        // AUTOMATIC DATA LOADING: Triggers when view appears
        .task {
            await loadPokemonDetails()
        }
    }
    
    
    // UI COMPOSITION: @ViewBuilder enables conditional view composition
    // Separates detail layout from loading/error states for clarity
    @ViewBuilder
    private func detailsView(_ details: DetailPokemon) -> some View {
        VStack(spacing: 15) {
            HStack(spacing: 30) {
                DetailCard(title: "ID", value: "#\(details.id)")
                DetailCard(title: "Weight", value: "\(viewModel.formatHeightWeight(value: details.weight)) kg")
                DetailCard(title: "Height", value: "\(viewModel.formatHeightWeight(value: details.height)) m")
            }
        }
        .padding(.horizontal)
    }
    
    // ASYNC DATA LOADING: Local state management with shared cache
    // Avoids redundant loading while providing immediate feedback
    private func loadPokemonDetails() async {
        // Early return if data already cached
        if pokemonDetails != nil { return }
        
        isLoadingDetails = true
        detailsError = nil
        
        do {
            // Load through ViewModel to maintain shared cache
            _ = try await viewModel.loadDetails(id: pokemon.pokemonId)
        } catch {
            detailsError = "Failed to load details: \(error.localizedDescription)"
        }

        isLoadingDetails = false
    }
}



struct DetailCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    PokemonDetailView(pokemon: Pokemon.samplePokemon, viewModel: PokemonViewModel())
}
