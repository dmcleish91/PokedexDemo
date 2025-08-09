//
//  PokedexDemoApp.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

import SwiftUI

@main
struct PokedexDemoApp: App {
    
    init() {
        let cache = URLCache(memoryCapacity: 50_000_000, diskCapacity: 100_000_000)
        URLCache.shared = cache
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
