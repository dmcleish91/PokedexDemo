//
//  PokemonDetailView.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/8/25.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    @ObservedObject var viewModel: PokemonViewModel
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private var pokemonDetails: DetailPokemon? {
        viewModel.pokemonDetails[pokemon.pokemonId]
    }

    var body: some View {
        VStack {
            PokemonView(pokemon: pokemon)
            
            Group {
                if isLoading {
                    ProgressView("Loading details...")
                        .frame(height: 100)
                } else if let details = pokemonDetails {
                    detailsView(details)
                } else {
                    Text("No details available")
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .navigationTitle(pokemon.name.capitalized)
        .navigationBarTitleDisplayMode(.large)
        .task {
            await loadPokemonDetails()
        }
    }
        
    
    @ViewBuilder
    private func detailsView(_ details: DetailPokemon) -> some View {
        VStack(spacing: 15) {
            HStack(spacing: 30) {
                DetailCard(title: "ID", value: "#\(details.id)")
                DetailCard(title: "Weight", value: "\(viewModel.formatHeightWeight(value: details.weight)) kg")
                DetailCard(title: "Height", value: "\(viewModel.formatHeightWeight(value: details.height)) m")
            }
        }
        .padding(.horizontal)
    }
    
    private func loadPokemonDetails() async {
        if pokemonDetails != nil { return }
        
        isLoading = true
        errorMessage = nil
        
        await viewModel.loadDetails(for: pokemon)
        isLoading = false
    }
}



struct DetailCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    PokemonDetailView(pokemon: Pokemon.samplePokemon, viewModel: PokemonViewModel())
}
