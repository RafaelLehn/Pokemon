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
    
    func returnPrimaryCollor() -> UIColor {
        return pokemonSelected?.primaryColor ?? .white
    }
}
