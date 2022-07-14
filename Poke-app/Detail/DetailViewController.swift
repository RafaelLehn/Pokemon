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
    @IBOutlet weak var pokeballFavoriteImageView: UIImageView!
    
    @IBOutlet private var labels: [UILabel]!
    
    var viewModel: DetailViewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = viewModel.returnPrimaryCollor()
        setupLabels()
        setupCard()
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        verifyDeviceOrientation()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        verifyDeviceOrientation()
    }
    
    func verifyDeviceOrientation() {
        if UIDevice.current.orientation.isLandscape {
            statFirstLabel.isHidden = true
            statSecondLabel.isHidden = true
            statThirdLabel.isHidden = true
            statQuarterLabel.isHidden = true
        } else {
            statFirstLabel.isHidden = false
            statSecondLabel.isHidden = false
            statThirdLabel.isHidden = false
            statQuarterLabel.isHidden = false
        }
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
    
    func setupGesture() {
        let pokeballTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(withdrawalMoreClick(tapGestureRecognizer:)))
        
        pokeballFavoriteImageView.addGestureRecognizer(pokeballTapGestureRecognizer)
        pokeballFavoriteImageView.isUserInteractionEnabled = true
    }
    
    @objc func withdrawalMoreClick(tapGestureRecognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2,
                       animations: {
            //Fade-out
            self.pokeballFavoriteImageView?.alpha = 0.4
        }) { (completed) in
            UIView.animate(withDuration: 0.2,
                           animations: {
                //Fade-out
                self.pokeballFavoriteImageView?.alpha = 1
            }) { (completed) in
                self.viewModel.sendPokemonToWebHook()
            }
        }
    }


}
