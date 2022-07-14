//
//  PokemonModel.swift
//  Poke-app
//
//  Created by Rafael on 7/11/22.
//

import Foundation
import UIKit

struct PokemonModel: Codable {
    var results: [Pokemon]
    var count: Int
    var next: String
    
    enum CodingKeys: String, CodingKey {
        case results
        case count
        case next
    }
    
}

struct Pokemon: Codable {
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
}

struct PokemonSelected : Codable {
    let name: String
    var weight: Int
    let height: Int
    let locationAreaEncounters: String
    let abilities: [Ability]
    var sprites: PokemonSprites
    let species: Species
    var types: [Category]
    var primaryColor: UIColor?
    let stats: [Stats]
    
    enum CodingKeys: String, CodingKey {
        case locationAreaEncounters = "location_area_encounters"
        case name, weight, height
        case abilities, sprites, species, types, stats
    }
}

struct Stats: Codable {
    let base_stat: Int
    let effort: Int
    let stat: Stat
}

struct Stat: Codable {
    let name: String
    let url: String
}

struct Ability: Codable {
    let ability: Species
    let isHidden: Bool
    let slot: Int

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

struct PokemonSprites : Codable {
    var front_default: String?
}

struct Category : Codable {
    var slot: Int
    var type: Species
    
}

struct Species : Codable {
    var name: String
    var url: String
}
