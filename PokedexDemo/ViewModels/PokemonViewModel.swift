//
//  ViewModel.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

/**
 * MVVM VIEWMODEL - CENTRAL DATA COORDINATOR
 * 
 * This ViewModel serves as the central hub for all Pokemon-related data and business logic.
 * It coordinates between the UI (Views) and data layer (Services), implementing the 
 * ViewModel pattern that's core to modern SwiftUI architecture.
 * 
 * Data Flow: Views ↔ PokemonViewModel ↔ PokemonService ↔ NetworkClient
 * See README.md "MVVM Architecture" section for detailed explanation
 */

import Foundation

// @MainActor ensures all UI updates happen on the main thread
// Critical for SwiftUI's reactive system and preventing threading issues
@MainActor
final class PokemonViewModel: ObservableObject {
    private let pokemonService: PokemonService
    private var searchTask: Task<Void, Never>?
    
    // REACTIVE STATE MANAGEMENT
    // @Published properties automatically trigger SwiftUI view updates
    // when data changes, creating a reactive data flow
    
    @Published var pokemonList: [Pokemon] = [] {
        didSet {
            updateFilteredPokemon()
        }
    }
    
    // PERFORMANCE: Detail Caching
    // Prevents redundant API calls for Pokemon details
    // Improves user experience and reduces network usage
    @Published var pokemonDetails: [Int: DetailPokemon] = [:]
    
    // PERFORMANCE: Search Debouncing
    // Cancels previous search tasks to prevent excessive filtering
    // 300ms delay ensures smooth user experience while typing
    @Published var searchText = "" {
        didSet {
            searchTask?.cancel()
            searchTask = Task { @MainActor in
                try? await Task.sleep(nanoseconds: 300_000_000)
                if !Task.isCancelled {
                    updateFilteredPokemon()
                }
            }
        }
    }
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var filteredPokemon: [Pokemon] = []
    
    private func updateFilteredPokemon() {
        filteredPokemon = searchText.isEmpty ? pokemonList : pokemonList.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func loadPokemon() async {
        isLoading = true
        errorMessage = nil
        
        do {
            pokemonList = try await pokemonService.getPokemon()
        } catch {
            errorMessage = "Failed to load Pokemon: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // ASYNC DATA LOADING WITH CACHING
    // Checks cache first to avoid redundant network calls
    // Demonstrates modern Swift concurrency patterns
    func loadDetails(id: Int) async throws -> DetailPokemon {
        if let cached = pokemonDetails[id] {
            return cached
        }
        
        let details = try await pokemonService.getDetailedPokemon(id: id)
        
        // Cache the result for future use
        pokemonDetails[id] = details
        
        return details
    }
    
    
    func formatHeightWeight(value: Int) -> String {
        let doubleValue = Double(value)
        let string = String(format: "%.2f", doubleValue / 10)
        
        return string
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // DEPENDENCY INJECTION
    // Allows for easy testing with mock services
    // Default parameter provides convenience while maintaining flexibility
    init(pokemonService: PokemonService = PokemonService()) {
        self.pokemonService = pokemonService
    }
}
    
