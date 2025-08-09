//
//  PokemonModel.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

/**
 * POKEMON DATA MODELS
 * 
 * Core data structures that define the shape of Pokemon data throughout the app.
 * These models conform to Swift protocols that enable JSON parsing, SwiftUI
 * integration, and data comparison.
 * 
 * Architecture: Model layer in MVVM pattern
 * See README.md "Models" section for detailed explanation
 */

import Foundation

// API RESPONSE WRAPPER: Represents paginated Pokemon list from API
struct PokemonPage: Codable {
    let count: Int
    let results: [Pokemon]
}

// CORE POKEMON MODEL
// Protocol conformances enable specific functionality:
struct Pokemon: Codable, Identifiable, Equatable {
    // UUID for SwiftUI Identifiable - enables efficient ForEach updates
    let id = UUID()
    let name: String
    let url: URL
    
    // CUSTOM JSON MAPPING: Excludes 'id' from JSON since it's auto-generated
    private enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
    // COMPUTED PROPERTY: pokemonId
    // Extracts numeric ID from API URL for image loading and API calls
    // Demonstrates Swift's computed property feature for derived data
    var pokemonId: Int {
        let pathComponents = url.pathComponents
        if let lastComponent =  pathComponents.last,
           let id = Int(lastComponent) {
            return id
        }
        return 0
    }
    
    // SAMPLE DATA: For SwiftUI previews and testing
    static var samplePokemon = Pokemon(name: "Pikachu", url: URL(string: "https://pokeapi.co/api/v2/pokemon/25/")!)
}

// DETAILED POKEMON DATA: Extended information from API
struct DetailPokemon: Codable {
    let id: Int
    let height: Int
    let weight: Int
}
