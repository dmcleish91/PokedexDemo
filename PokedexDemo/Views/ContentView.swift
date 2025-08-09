//
//  ContentView.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = PokemonViewModel()
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                    ForEach(viewModel.filteredPokemon) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon, viewModel: viewModel)) {
                            PokemonView(pokemon: pokemon)
                        }
                    }
                }
                .animation(.easeIn(duration: 0.3), value: viewModel.filteredPokemon.count)

            }
            .navigationTitle(Text("Pokedex"))
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText)
            .task {
                await viewModel.loadPokemon()
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading Pokemon...")
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    ContentView()
}
