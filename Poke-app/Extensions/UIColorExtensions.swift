//
//  UIColorExtensions.swift
//  Poke-app
//
//  Created by Rafael on 7/13/22.
//

import Foundation
import UIKit

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
