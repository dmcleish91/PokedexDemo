//
//  Helpers.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

/**
 * UTILITY HELPERS
 * 
 * Contains utility functions and Swift extensions that provide reusable
 * functionality across the app. Demonstrates Swift extension patterns
 * and comprehensive error handling.
 * 
 * Pattern: Swift extensions for enhanced functionality
 * See README.md "Code Organization" for project structure details
 */

import Foundation

// COMPREHENSIVE ERROR HANDLING
// Custom error types provide specific context for debugging
// LocalizedError protocol ensures user-friendly error messages
enum BundleDecodeError: Error, LocalizedError {
    case fileNotFound(String)
    case loadFailed(String)
    case decodeFailed(String, underlying: Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let file):
            return "File not found: \(file)"
        case .loadFailed(let file):
            return "Failed to load file: \(file)"
        case .decodeFailed(let file, let underlying):
            return "Decoding failed for \(file): \(underlying.localizedDescription)"
        }
    }
}

// SWIFT EXTENSIONS
// Extends Bundle with custom decode functionality
// Demonstrates how to add functionality to existing types
extension Bundle {
    // GENERIC BUNDLE DECODING: Type-safe local file loading
    // Used for loading the local pokemon.json data
    func decode<T: Decodable>(file: String) throws -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            throw BundleDecodeError.fileNotFound(file)
        }
        
        let data: Data
        do { data = try Data(contentsOf: url) }
        catch { throw BundleDecodeError.loadFailed(file) }
        
        do { return try JSONDecoder().decode(T.self, from: data) }
        catch { throw BundleDecodeError.decodeFailed(file, underlying: error) }
        
    }
}
