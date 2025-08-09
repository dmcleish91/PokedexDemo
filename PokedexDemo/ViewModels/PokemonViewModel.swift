//
//  ViewModel.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

import Foundation

@MainActor
final class PokemonViewModel: ObservableObject {
    private let pokemonService = PokemonService()
    
    @Published var pokemonList: [Pokemon] = []
    @Published var pokemonDetails: [Int: DetailPokemon] = [:]
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var filteredPokemon: [Pokemon] {
        return searchText.isEmpty ? pokemonList : pokemonList.filter { pokemon in
            pokemon.name.localizedCaseInsensitiveContains(searchText)
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
    
    func loadDetails(for pokemon: Pokemon) async {
        let id = pokemon.pokemonId
        
        if pokemonDetails[id] != nil { return }
        
        do {
            let details = try await pokemonService.getDetailedPokemon(id: id)
            pokemonDetails[id] = details
        } catch {
            errorMessage = "Failed to load details: \(error.localizedDescription)"
        }
    }
    
    
    func formatHeightWeight(value: Int) -> String {
        let doubleValue = Double(value)
        let string = String(format: "%.2f", doubleValue / 10)
        
        return string
    }
}
    
