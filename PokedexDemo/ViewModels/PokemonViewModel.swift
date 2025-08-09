//
//  ViewModel.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

import Foundation

@MainActor
final class PokemonViewModel: ObservableObject {
    private let pokemonService: PokemonService
    private var searchTask: Task<Void, Never>?
    
    @Published var pokemonList: [Pokemon] = [] {
        didSet {
            updateFilteredPokemon()
        }
    }
    @Published var pokemonDetails: [Int: DetailPokemon] = [:]
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
    
    func loadDetails(id: Int) async throws -> DetailPokemon {
        if let cached = pokemonDetails[id] {
            return cached
        }
        
        let details = try await pokemonService.getDetailedPokemon(id: id)
        
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
    
    init(pokemonService: PokemonService = PokemonService()) {
        self.pokemonService = pokemonService
    }
}
    
