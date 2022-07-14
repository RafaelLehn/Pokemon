//
//  DetailViewModel.swift
//  Poke-app
//
//  Created by Rafael on 7/13/22.
//

import Foundation
import UIKit

class DetailViewModel {
    var pokemonSelected: PokemonSelected?
    
    let service = PokemonService()
    
    func returnPrimaryCollor() -> UIColor {
        return pokemonSelected?.primaryColor ?? .white
    }
    
    func sendPokemonToWebHook() {
        guard let pokemonSelected = pokemonSelected else {
            return
        }

        service.sendFavoritePokemonToWebHook(pokemon: pokemonSelected)
    }
    
}
