//
//  HomeViewModel.swift
//  Poke-app
//
//  Created by Rafael on 7/13/22.
//

import Foundation
import UIKit

protocol HomeViewModelDelegate {
    func returnPokemons()
    func returnError()
}

class HomeViewModel {
    
    var pokemonPathURL = "https://pokeapi.co/api/v2/pokemon/"
    
    var pokemonList: [PokemonSelected] = []
    
    var searchPokemonList: [PokemonSelected] = []
    
    let service = PokemonService()
    
    var delegate: HomeViewModelDelegate?
    
    var isSearching = false
    
    func fetchPokemon() {
        service.fetchPokemon(pokemonPath: pokemonPathURL) { pokemon, pokemonSelected, error in
            
            guard let pokemon = pokemon else {
                return
            }

            guard var pokemonSelected = pokemonSelected else {
                return
            }

            if error != nil {
                self.pokemonPathURL = "https://pokeapi.co/api/v2/pokemon/"
                self.pokemonList.removeAll()
                self.delegate?.returnError()
                return
            }
            
            
            pokemonSelected.primaryColor = UIColor().pokemonColor(color: pokemonSelected.types.last?.type.name ?? "")
            
            self.pokemonPathURL = pokemon.next
            self.pokemonList.append(pokemonSelected)
            self.delegate?.returnPokemons()
        }
    }
    
    
}
