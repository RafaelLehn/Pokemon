//
//  PokemonService.swift
//  Poke-app
//
//  Created by Rafael on 7/13/22.
//

import Foundation
import UIKit

class PokemonService {
    
    func fetchPokemon(pokemonPath: String, completion: @escaping (PokemonModel?, PokemonSelected?, Error?) -> Void) {
        
        let defaultSession = URLSession(configuration: .default)
            
        if let url = URL(string: pokemonPath) {
                
            let request = URLRequest(url:url)
            let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                    
            guard error == nil else {
                print ("error: ", error!)
                completion(nil, nil, error)
                return
            }
                    
            guard data != nil else {
                print("No data object")
                return
            }
                    
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("response is: ", response!)
                return
            }
                    
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
                    
            DispatchQueue.main.async {
                            
                guard let result = try? JSONDecoder().decode(PokemonModel.self, from: data!) else {
                    print("Error Parsing JSON")
                    return
                }

                let listaPoke: [Pokemon]?
                listaPoke = result.results
                
                guard let newLista = listaPoke else {
                    return
                }
                DispatchQueue.main.async {
                    for pokemon in newLista {
                        self.getSprite(url: pokemon.url) { newPokemon in
                            
                            completion(result, newPokemon, nil)
                        }
                    }
                }
            }
            })
            dataTask.resume()
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion:@escaping (UIImage) -> ()) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                completion(UIImage(data: data)!)
            }
        }
    }
    
    func getSprite(url: String, completion:@escaping (PokemonSelected) -> ()) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            print(data)
            var pokemon = try! JSONDecoder().decode(PokemonSelected.self, from: data)
            
            DispatchQueue.main.async {
                self.downloadImage(from: URL(string: pokemon.sprites.front_default!)!) { image in
                    
                    pokemon.image = image
                    pokemon.primaryColor = UIColor().pokemonColor(color: pokemon.types.last?.type.name ?? "")
                    
                    completion(pokemon)
                }
            }
        }.resume()
    }
    
    
}

extension UIColor {
    func pokemonColor(color: String) -> UIColor{
        switch color {
        case "fire": return .systemRed
        case "poison": return .systemGreen
        case "water": return .systemBlue
        case "eletric": return .systemYellow
        case "psychic": return .systemPurple
        case "normal": return .systemOrange
        case "ground": return .systemGray
        case "flying": return .systemTeal
        case "fairy": return .systemPink
        default: return .systemIndigo
        }
    }
}
