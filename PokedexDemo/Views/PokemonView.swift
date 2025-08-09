//
//  PokemonView.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/8/25.
//

import SwiftUI

struct PokemonView: View {
    let pokemon: Pokemon
    let dimensions: Double = 140
    
    var body: some View {
        VStack {
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
