//
//  PokedexDemoApp.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

/**
 * APPLICATION ENTRY POINT
 * 
 * This file serves as the main entry point for the PokedexDemo application.
 * It demonstrates SwiftUI app lifecycle and configures app-level optimizations.
 * 
 * Architecture: This app follows MVVM pattern - see README.md for detailed explanation
 * Data Flow: App → ContentView → PokemonViewModel → PokemonService → NetworkClient
 */

import SwiftUI

@main
struct PokedexDemoApp: App {
    
    init() {
        // Configure image caching for better performance across the app
        // 50MB memory cache, 100MB disk cache for AsyncImage optimization
        // See README "Performance Optimizations" section for details
        let cache = URLCache(memoryCapacity: 50_000_000, diskCapacity: 100_000_000)
        URLCache.shared = cache
    }
    
    var body: some Scene {
        WindowGroup {
            // Entry point to the main UI - starts the MVVM data flow
            ContentView()
        }
    }
}
