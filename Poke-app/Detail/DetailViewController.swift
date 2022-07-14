//
//  DetailViewController.swift
//  Poke-app
//
//  Created by Rafael on 7/12/22.
//

import UIKit
import Kingfisher

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
        self.navigationController?.navigationBar.tintColor = viewModel.returnPrimaryCollor()
        setupLabels()
        setupCard()
    }
    
    func setupLabels() {
        guard let pokemon = viewModel.pokemonSelected else { return }
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
        KF.url(URL(string: pokemon.sprites.front_default!)).set(to: pokemonImageView)
    }
    
    func setupCard() {
        cardPokemonView.backgroundColor = viewModel.returnPrimaryCollor()
        cardPokemonView.layer.cornerRadius = cardPokemonView.layer.frame.width/10
        cardPokemonView.layer.borderWidth = 0.0
        cardPokemonView.layer.shadowColor = viewModel.returnPrimaryCollor().cgColor
        cardPokemonView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardPokemonView.layer.shadowRadius = 7.0
        cardPokemonView.layer.shadowOpacity = 0.9
        cardPokemonView.layer.masksToBounds = false
    }
    
    


}
