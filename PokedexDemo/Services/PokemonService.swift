//
//  PokemonManager.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

/**
 * POKEMON DATA SERVICE
 * 
 * Service layer that abstracts data access from the ViewModel. This separation
 * allows for easy testing (mock services) and flexibility in data sources.
 * 
 * Architecture: Part of the Service layer in MVVM pattern
 * Data Sources: Local JSON (pokemon list) + Remote API (details)
 * See README.md "Service Layer" for architecture details
 */

import Foundation

class PokemonService {
    private let baseURL: String = "https://pokeapi.co/api/v2"
    
    // DEPENDENCY INJECTION
    // NetworkClient is injected, making this service easily testable
    // Can be mocked for unit tests or replaced with different implementations
    private let client = NetworkClient()
    
    // DATA SOURCE STRATEGY
    // Pokemon list: Local JSON for fast initial load
    // Pokemon details: Remote API for up-to-date information
    // This hybrid approach balances performance with data freshness
    func getPokemon() async throws -> [Pokemon] {
        let page: PokemonPage = try Bundle.main.decode(file: "pokemon.json")
        return page.results
    }
    
    // REMOTE API CALLS: Fetch detailed Pokemon data
    // Uses the generic NetworkClient for type-safe API communication
    func getDetailedPokemon(id: Int) async throws -> DetailPokemon {
        guard let url = URL(string: "\(baseURL)/pokemon/\(id)") else {
            throw NetworkError.invalidURL
        }
        return try await client.fetch(url)
    }
}
