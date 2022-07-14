//
//  PokemonCollectionViewCell.swift
//  Poke-app
//
//  Created by Rafael on 7/11/22.
//

import UIKit
import Kingfisher

class PokemonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonCategoryLabel: UILabel!
    @IBOutlet weak var categoryBackgroundView: UIView!
    
    func updateCell(pokemon: PokemonSelected) {
        
        pokemonNameLabel.text = pokemon.name
        KF.url(URL(string: pokemon.sprites.front_default!)).set(to: pokemonImageView)
        pokemonCategoryLabel.text = pokemon.types.last?.type.name
        categoryBackgroundView.layer.cornerRadius = 10
        
        self.contentView.backgroundColor = pokemon.primaryColor
        self.contentView.layer.cornerRadius = self.layer.frame.width/10
        self.layer.borderWidth = 0.0
        self.layer.shadowColor = pokemon.primaryColor?.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        
    }
}
