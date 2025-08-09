//
//  PokemonView.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/8/25.
//

/**
 * REUSABLE POKEMON COMPONENT
 * 
 * Self-contained view component that displays Pokemon information.
 * Demonstrates component reusability and modern SwiftUI image loading.
 * 
 * Usage: Used in both list view and detail view
 * Pattern: Stateless, reusable UI component
 */

import SwiftUI

struct PokemonView: View {
    let pokemon: Pokemon
    let dimensions: Double = 140
    
    var body: some View {
        VStack {
            // MODERN IMAGE LOADING
            // AsyncImage handles URL loading, caching, and placeholder states automatically
            // Demonstrates SwiftUI's built-in async capabilities
            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.pokemonId).png")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)
                
            } placeholder: {
                ProgressView()
                    .frame(width: dimensions, height: dimensions)
            }
            .background(.thinMaterial)
            .clipShape(Circle())
            // ACCESSIBILITY: Proper labels ensure the app is inclusive for all users
            // See README.md "Accessibility" section for best practices
            .accessibilityLabel("Pokemon \(pokemon.name)")
            .accessibilityHint("Tap to view details")
            
            Text("\(pokemon.name.capitalized)")
                .font(.system(size: 18, weight: .regular, design: .monospaced))
                .padding(.bottom, 20)
                .accessibilityLabel("Pokemon name: \(pokemon.name)")
        }
    }
}

#Preview {
    PokemonView(pokemon: Pokemon.samplePokemon)
}
