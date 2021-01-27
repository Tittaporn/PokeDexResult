//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Lee McCormick on 1/26/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pokeImageView: UIImageView!
    @IBOutlet weak var pokeNameLabel: UILabel!
    @IBOutlet weak var pokeIDLabel: UILabel!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    // MARK: - Helper Fuctions
    func fetchSpriteAndUpdateViews(for pokemon: Pokemon) {
        PokemonController.fetchSprite(for: pokemon) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let sprite):
                    self.pokeImageView.image = sprite
                    self.pokeNameLabel.text = pokemon.name.capitalized
                    self.pokeIDLabel.text = String(pokemon.id)
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
            
        }
    }
}

// MARK: - Extensions
extension PokemonViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text?.lowercased() else { return }
        PokemonController.fetchPokemon(searchTerm: searchTerm) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemon):
                    self.fetchSpriteAndUpdateViews(for: pokemon)
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
}

/* NOTE
 DELETE THIS AND REBUILD FOR BETTER READING CODE.
 
 // MARK: - Helper Fuctions
 func fetchPokemon() {
 PokemonController.fetchPokemon(searchTerm: "moltres") { (result) in
 
 //PUT All Theses on the Main Thread
 // Anything we perform inside is performed and happened in the main thread
 DispatchQueue.main.async {
 
 // switch the result that get back from PokemonController.fetchPokemon()
 switch result {
 case .success(let pokemon): //naming the pokemon that come back with success
 // display the name, id and image on VC
 // self because we are in the clousure.To refer to anything else outside the closure int the class.
 // Everytime we update view we update view in the main thread only.
 // These are still in the background thread
 // We need to priority UI disyplay for User experience.
 /*
 self.pokeNameLabel.text = pokemon.name
 self.pokeIDLabel.text = String(pokemon.id) //cast it as String or interpolate it.
 */
 PokemonController.fetchSprite(for: pokemon) { (<#Result<UIImage, PokemonError>#>) in
 <#code#>
 }
 case .failure(let error):
 // using the extension ViewController to present error
 self.presentErrorToUser(localizedError: error)
 }
 }
 }
 }
 }
 */
