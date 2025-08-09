//
//  NetworkClient.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/9/25.
//

/**
 * GENERIC NETWORK CLIENT
 * 
 * Demonstrates modern Swift networking with generic programming and comprehensive
 * error handling. This client can be reused for any Codable type, following
 * the DRY principle and providing consistent error handling across the app.
 * 
 * Pattern: Generic programming for type safety and reusability
 * See README.md "Modern Swift Features" for detailed explanation
 */

import Foundation

// COMPREHENSIVE ERROR HANDLING
// Custom error types provide specific context for debugging
// LocalizedError protocol ensures user-friendly error messages
enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case invalidURL
    case httpError(Int)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response"
        case .invalidURL:
            return "Invalid URL"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}

struct NetworkClient {
    // MODERN CONCURRENCY: Async/Await
    // Replaces completion handler callbacks with cleaner, more readable async code
    // Better error propagation and cancellation support
    
    // GENERIC PROGRAMMING: Type-safe and reusable
    // Works with any Codable type, eliminating code duplication
    // Provides compile-time type safety for API responses
    func fetch<T: Decodable>(_ url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // RESPONSE VALIDATION: Ensure we have a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // HTTP STATUS CODE VALIDATION: Handle server errors gracefully
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        
        // JSON DECODING: With proper error handling
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
