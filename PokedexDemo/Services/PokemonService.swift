//
//  PokemonManager.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

import Foundation

class PokemonService {
    private let client = NetworkClient()
    
    func getPokemon() async throws -> [Pokemon] {
        let page: PokemonPage = try Bundle.main.decode(file: "pokemon.json")
        return page.results
    }
    
    func getDetailedPokemon(id: Int) async throws -> DetailPokemon {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
        return try await client.fetch(url)
    }
}
