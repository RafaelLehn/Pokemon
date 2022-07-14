//
//  PokemonService.swift
//  Poke-app
//
//  Created by Rafael on 7/13/22.
//

import Foundation

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
                        self.getPokemon(url: pokemon.url) { newPokemon in
                            
                            completion(result, newPokemon, nil)
                        }
                    }
                }
            }
            })
            dataTask.resume()
        }
    }
    
    func getPokemon(url: String, completion:@escaping (PokemonSelected) -> ()) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            print(data)
            let pokemon = try! JSONDecoder().decode(PokemonSelected.self, from: data)
            
            DispatchQueue.main.async {
                completion(pokemon)
            }
        }.resume()
    }
    
    func sendFavoritePokemonToWebHook(pokemon: PokemonSelected) {
        var pokemonJson:[String:Any]  = [:]
        var abilitiesJson:[String:Any]  = [:]
        var typeJson:[String:Any]  = [:]
        
        typeJson["Type:"] = pokemon.stats.last?.stat.name
        
        for index in 0...3 {
            abilitiesJson[(pokemon.stats[index].stat.name)] = pokemon.stats[index].base_stat
        }
        
        pokemonJson["Name:"] = pokemon.name
        pokemonJson["Abilities:"] = abilitiesJson
        pokemonJson["Type:"] = typeJson
        
        guard let url = URL(string: "https://webhook.site/85294a03-0a6c-488b-b075-3c9176152ca8") else { return }
        let messageJson: [String: Any] = pokemonJson
        let jsonData = try? JSONSerialization.data(withJSONObject: messageJson)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
    }
    
}
