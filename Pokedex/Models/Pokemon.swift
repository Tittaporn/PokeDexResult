//
//  Pokemon.swift
//  Pokedex
//
//  Created by Lee McCormick on 1/26/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import Foundation

struct Pokemon: Decodable {
    let name: String
    let id: Int
    let sprites: Sprites
    //let weight: Int
    //let moves: [secondLavelObject]
    //let nicknames: [String] >> Does not exist, so it would crash.
}

struct Sprites: Decodable {
    let front_shiny: URL
}

/* NOTE SECOND LEVEL OBJECT
 struct secondLavelObject {
 let move: Move
 }
 
 struct Move {
 let name: String
 let url: URL
 }
 */

/* This is an informatino that I want to capture from Pokemon
 https://pokeapi.co/api/v2/pokemon/12
 
 "name": "charizard",
 "id" : 6
 "sprites": {
 "front_shinny" : "url.."
 }
 "nicknames": ["Chary", "Fire!"] // Don't exist in https://pokeapi.co/api/v2/pokemon/12
 
 */
