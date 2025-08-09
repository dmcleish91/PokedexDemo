//
//  ContentView.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

/**
 * MAIN USER INTERFACE
 * 
 * Primary view that serves as the UI entry point and coordinates the main
 * Pokemon list interface. Demonstrates modern SwiftUI patterns including
 * navigation, state management, and reactive UI updates.
 * 
 * UI Flow: ContentView → PokemonView → PokemonDetailView
 * Data Flow: UI ↔ PokemonViewModel ↔ Data Services
 * See README.md "SwiftUI Patterns" for detailed explanation
 */

import SwiftUI

struct ContentView: View {
    // STATE MANAGEMENT
    // @StateObject creates and owns the ViewModel instance
    // Ensures proper lifecycle management and memory handling
    @StateObject private var viewModel = PokemonViewModel()
    @State private var showingError = false
    
    // PERFORMANCE: Adaptive Grid Layout
    // LazyVGrid only renders visible items, improving performance with large datasets
    // Adaptive columns automatically adjust to screen size for responsive design
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    
    var body: some View {
        // MODERN NAVIGATION
        // NavigationStack provides the navigation container for iOS 16+
        // Replaces NavigationView with better performance and flexibility
        NavigationStack {
            ScrollView {
                // PERFORMANCE: LazyVGrid with ForEach
                // Only renders visible Pokemon for better performance
                // ForEach requires Identifiable conformance for efficient updates
                LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                    ForEach(viewModel.filteredPokemon) { pokemon in
                        // NAVIGATION: Data passing between views
                        // Passes both Pokemon data and shared ViewModel instance
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon, viewModel: viewModel)) {
                            PokemonView(pokemon: pokemon)
                        }
                        // ACCESSIBILITY: Inclusive design
                        .accessibilityLabel("View details for \(pokemon.name)")
                    }
                }
                // SMOOTH ANIMATIONS: Reactive to data changes
                .animation(.easeIn(duration: 0.3), value: viewModel.filteredPokemon.count)

            }
            .navigationTitle(Text("Pokedex"))
            .navigationBarTitleDisplayMode(.inline)
            // REACTIVE SEARCH: Automatically filters data
            .searchable(text: $viewModel.searchText)
            // AUTOMATIC DATA LOADING: Triggers when view appears
            .task {
                await viewModel.loadPokemon()
            }
        }
        // LOADING STATES: User feedback during async operations
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading Pokemon...")
            }
        }
        // ERROR HANDLING: User-friendly error display with recovery
        .alert("Error", isPresented: $showingError) {
            Button("OK") { viewModel.clearError() }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        // REACTIVE ERROR HANDLING: Automatically shows alerts when errors occur
        .onChange(of: viewModel.errorMessage) { _, newValue in
            showingError = newValue != nil
        }
    }
}

#Preview {
    ContentView()
}
