//
//  PokemonModel.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

import Foundation

struct PokemonPage: Codable {
    let count: Int
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let url: URL
    
    private enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
    var pokemonId: Int {
        let pathComponents = url.pathComponents
        if let lastComponent =  pathComponents.last,
           let id = Int(lastComponent) {
            return id
        }
        return 0
    }
    
    static var samplePokemon = Pokemon(name: "Pikachu", url: URL(string: "https://pokeapi.co/api/v2/pokemon/25/")!)
}

struct DetailPokemon: Codable {
    let id: Int
    let height: Int
    let weight: Int
}
