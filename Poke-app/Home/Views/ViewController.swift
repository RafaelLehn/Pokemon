//
//  ViewController.swift
//  Poke-app
//
//  Created by Rafael on 7/11/22.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.delegate = self
        searchBar.delegate = self
        collectionView.register(UINib(nibName: "ErrorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "errorCell")
        
        fetchPokemonsStart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func fetchPokemonsStart() {
        self.collectionView.isHidden = true
        self.loadingView.startAnimating()
        self.loadingView.isHidden = false
        viewModel.fetchPokemon()
    }
    
    func fetchPokemonsEnd() {
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
        self.loadingView.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detail = segue.destination as? DetailViewController,
           let object = sender as? PokemonSelected {
            
            detail.viewModel.pokemonSelected = object
        }
        
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if viewModel.isSearching == false {
            viewModel.isSearching = true
            self.searchBar.showsCancelButton = true
            viewModel.searchPokemonList = viewModel.pokemonList
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.viewModel.searchPokemonList = []
        viewModel.isSearching = false
        self.searchBar.showsCancelButton = false
        self.searchBar.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        self.collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text! == ""  {
            self.viewModel.searchPokemonList = viewModel.pokemonList
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        } else {
            viewModel.searchPokemonList = viewModel.pokemonList.filter({ (pokemon) -> Bool in
                return (pokemon.name.localizedCaseInsensitiveContains(String(searchBar.text!)))
            })
            collectionView.reloadData()
        }
        
    }
}

extension ViewController: HomeViewModelDelegate {
    func returnPokemons() {
        fetchPokemonsEnd()
    }
    
    func returnError() {
        fetchPokemonsEnd()
    }
}

extension ViewController: ErrorCollectionViewCellDelegate {
    func tryAgain() {
        fetchPokemonsStart()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if viewModel.pokemonList.isEmpty {
            return 1
        }
        
        if viewModel.isSearching {
            return viewModel.searchPokemonList.count
        }
        
        return viewModel.pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if viewModel.pokemonList.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "errorCell", for: indexPath) as! ErrorCollectionViewCell
            cell.delegate = self
//            cell.pokemonNameLabel.text = "did not return pokemon's, try Again"
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokemonCell", for: indexPath) as! PokemonCollectionViewCell
        
        cell.updateCell(pokemon: viewModel.pokemonList[indexPath.item])
        
        if viewModel.isSearching {
            cell.updateCell(pokemon: viewModel.searchPokemonList[indexPath.item])
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2,
                       animations: {
            cell?.contentView.alpha = 0.2
            
        }) { (completed) in
            UIView.animate(withDuration: 0.2,
                           animations: {
                cell?.contentView.alpha = 1
            }) { (completed) in
                if !self.viewModel.pokemonList.isEmpty {
                    if self.viewModel.isSearching {
                        self.performSegue(withIdentifier: "goToDetail", sender: self.viewModel.searchPokemonList[indexPath.item])
                    } else {
                        self.performSegue(withIdentifier: "goToDetail", sender: self.viewModel.pokemonList[indexPath.item])
                    }
                    
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !viewModel.isSearching {
            if (indexPath.row == viewModel.pokemonList.count - 1 ) { //it's your last cell
                //Load more data & reload your collection view
                self.fetchPokemonsStart()
                collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let orientation = UIApplication.shared.statusBarOrientation
        if(orientation == .landscapeLeft || orientation == .landscapeRight)
        {
            return CGSize(width: collectionView.frame.size.width/4, height: collectionView.frame.size.height/1)
        }
        else{
            return CGSize(width: collectionView.frame.size.width/2.3, height: collectionView.frame.size.height/1)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
