//
//  PokemonError.swift
//  Pokedex
//
//  Created by Lee McCormick on 1/26/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import Foundation

// This is custom error for user to see
enum PokemonError: LocalizedError {
    case invalidURL
    case throwError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String {
        switch self { //self is PokemonError
        case .invalidURL:
            return "Unable to reach the server."
        case .throwError(let error): //This one take in the error, so named the error
            return error.localizedDescription // From apple to throw error nice English for user or us.
        case .noData:
            return "The server responded with no data."
        case .unableToDecode:
            return "Unable to turn the data into the an image."
        }
    }
}
