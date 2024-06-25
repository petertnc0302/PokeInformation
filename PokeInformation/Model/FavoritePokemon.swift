//
//  FavoritePokemon.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 24/6/24.
//

import Foundation

struct FavoritePokemon: Codable, Equatable {
    let id: Int
    let name: String
    let imageUrl: String
    let url: String
    let height: Int?
    let weight: Int?
    let base_experience: Int?
    let types: [PokemonType]?
    let stats: [PokemonStat]?
    let abilities: [PokemonAbility]?
    let habitat: NamedAPIResource?
    let moves: [PokemonMove]?

    static func ==(lhs: FavoritePokemon, rhs: FavoritePokemon) -> Bool {
        return lhs.id == rhs.id
    }
}
