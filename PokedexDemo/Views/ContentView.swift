//
//  ContentView.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PokemonViewModel()
    @State private var showingError = false
    
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
                        .accessibilityLabel("View details for \(pokemon.name)")
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
        .alert("Error", isPresented: $showingError) {
            Button("OK") { viewModel.clearError() }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
            showingError = newValue != nil
        }
    }
}

#Preview {
    ContentView()
}
