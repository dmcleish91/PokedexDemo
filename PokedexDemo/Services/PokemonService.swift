//
//  PokemonManager.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

import Foundation

class PokemonService {
    private let baseURL: String = "https://pokeapi.co/api/v2"
    private let client = NetworkClient()
    
    func getPokemon() async throws -> [Pokemon] {
        let page: PokemonPage = try Bundle.main.decode(file: "pokemon.json")
        return page.results
    }
    
    func getDetailedPokemon(id: Int) async throws -> DetailPokemon {
        guard let url = URL(string: "\(baseURL)/pokemon/\(id)") else {
            throw NetworkError.invalidURL
        }
        return try await client.fetch(url)
    }
}
