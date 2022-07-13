//
//  DetailViewController.swift
//  Poke-app
//
//  Created by Rafael on 7/12/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonCategoryLabel: UILabel!
    @IBOutlet weak var cardPokemonView: UIView!
    @IBOutlet weak var statFirstLabel: UILabel!
    @IBOutlet weak var statSecondLabel: UILabel!
    @IBOutlet weak var statThirdLabel: UILabel!
    @IBOutlet weak var statQuarterLabel: UILabel!
    
    @IBOutlet private var labels: [UILabel]!
    
    var viewModel: DetailViewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let pokemon = viewModel.pokemon else {
            return
        }
        
        self.navigationController?.navigationBar.tintColor = pokemon.primaryColor
        
        
        setupLabels(pokemon: pokemon)
        setupCard(pokemon: pokemon)
    }
    
    func setupLabels(pokemon: PokemonSelected) {
        for index in 0...3 {
            let statusName = pokemon.stats[index].stat.name
            let baseStat = pokemon.stats[index].base_stat
            switch index {
            case 0: statFirstLabel.text = "\(statusName): \(baseStat)"
            case 1: statSecondLabel.text = "\(statusName): \(baseStat)"
            case 2: statThirdLabel.text = "\(statusName): \(baseStat)"
            case 3: statQuarterLabel.text = "\(statusName): \(baseStat)"
            default:
                statQuarterLabel.text = ""
            }
        }

        pokemonNameLabel.text = pokemon.name
        pokemonCategoryLabel.text = "Type: \(pokemon.types.last!.type.name)"
        pokemonImageView.image = pokemon.image
    }
    
    func setupCard(pokemon: PokemonSelected) {
        cardPokemonView.backgroundColor = pokemon.primaryColor
        cardPokemonView.layer.cornerRadius = cardPokemonView.layer.frame.width/10
        cardPokemonView.layer.borderWidth = 0.0
        cardPokemonView.layer.shadowColor = pokemon.primaryColor?.cgColor
        cardPokemonView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardPokemonView.layer.shadowRadius = 7.0
        cardPokemonView.layer.shadowOpacity = 0.9
        cardPokemonView.layer.masksToBounds = false
    }
    
    


}
