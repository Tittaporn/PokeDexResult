//
//  PokemonController.swift
//  Pokedex
//
//  Created by Lee McCormick on 1/26/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import UIKit //For UIImage

class PokemonController {
    // MARK: -  URL
    // https://pokeapi.co/api/v2/pokemon/6
    static let baseURL = URL(string: "https://pokeapi.co/api/v2")
    static let pokemonEndpoint = "pokemon"
    
    // Don't not need S.O.T. and Shared because only fetch a Pokemon
    
    // MARK: - fetchPokemon
    // We gonna complete of result have 2 values (Result<TypeOfSomething, Error>) 1) What we get from completion 2) Error
    //                         moltres
    static func fetchPokemon(searchTerm: String, completion: @escaping (Result<Pokemon,PokemonError>) -> Void) {
        // 1) URL
        // completion(.failure(<#T##PokemonError#>)) >> always 2 case .success or failure
        // (.failure(.invalidURL) >> Access it from PokemonError
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        // https://pokeapi.co/api/v2
        
        let pokemonURL = baseURL.appendingPathComponent(pokemonEndpoint)
        // https://pokeapi.co/api/v2/pokemon
        
        let finalURL = pokemonURL.appendingPathComponent(searchTerm)
        print(finalURL)  // https://pokeapi.co/api/v2/pokemon/moltres
        
        // 2) DataTask
        //     data, response , error are optional.    ?    ?   ?
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            // 3) Handler error
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.throwError(error))) //Exist the function and the same time as completion.
                
                /* This two line same as the line up here ^.
                 completion(.failure(.throwError(error)))
                 return
                 */
            }
            
            // 4) Check Data
            guard let data = data else { return completion(.failure(.noData)) }
            
            // 5) Decode Data
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                completion(.success(pokemon))
            } catch let decodeError { // you can named the error to decodeError, if xCode give you automatic error after catch.
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(decodeError)")
                print("Description: \(decodeError.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.throwError(decodeError)))
            }
            
        }.resume() //Have to resume as soon as we get data back the code will continue to execute. Resume to dataTask work.
    }
    
    // MARK: - fetchSprite
    static func fetchSprite(for pokemon: Pokemon, completion: @escaping (Result<UIImage, PokemonError>) -> Void) {
        
        let url = pokemon.sprites.front_shiny //Get URL From sprites
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.throwError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            // Apple to handle UIImage Data with Using grard instead of do catch
            guard let sprite = UIImage(data: data) else { return completion(.failure(.unableToDecode))}
            completion(.success(sprite))
            
        }.resume()
    }
}



/* NOTE
 
 Completion Handler
 
 completion >> == Call back function. the completion will run after fetchPokemon done.
 
 What’s a Completion Handler?
 Completion handlers can be a bit confusing the first time you run in to them. On the one hand, they’re a variable or argument but, on the other hand, they’re a chunk of code. Weird if you’re not used to that kind of thing (a.k.a., closures).
 
 “Closures are self-contained blocks of functionality that can be passed around and used in your code.”
 iOS Developer Documentation on Closures
 Completion handlers are super convenient when your app is doing something that might take a little while, like making an API call, and you need to do something when that task is done, like updating the UI to show the data. You’ll see completion handlers in Apple’s APIs like dataTask(with request: completionHandler:) and they can be pretty handy in your own code.
 
 https://grokswift.com/completion-handlers-in-swift/
 
 //______________________________________________________________________________________
 
 
 What Is @escaping and @nonescaping CompletionHandler?
 If you have seen my code where I have used loadImages, you’ll have seen that inside the function block type is escaping. After Swift 3.0, blocks (in Swift closures) are non-escaping by default.
 So what is the main difference between these? And what about performing any asynchronous tasks inside the function, like URLSession , or using GCD blocks for executing any operations, storing offline data in SQL or core data?
 In this case, it will show you the error so that you can fix it. It will not accept a non-escaping type block. You have to fix it by using an escaping block.
 https://medium.com/better-programming/completion-handler-in-swift-4-2-671f12d33178
 //______________________________________________________________________________________
 
 Fundamentals of Callbacks for Swift Developers
 
 What are callbacks?
 Let’s approach the definition from a “big picture” scenario:
 
 When we’re building software, we’re either using APIs, or building APIs, are we not? We’re either using code that “hooks into” what other developers have designed and made available to us, or we’re creating code that other code will “hook into” and interact with, even if the “other code” is written by us in our own app.
 https://www.andrewcbancroft.com/2016/02/15/fundamentals-of-callbacks-for-swift-developers/
 
 */
