//
//  Helpers.swift
//  PokedexDemo
//
//  Created by Dwight Mcleish Jr on 8/7/25.
//

import Foundation

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

extension Bundle {
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
