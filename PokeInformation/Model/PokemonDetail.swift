//
//  PokemonDetail.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 22/6/24.
//

import Foundation

struct PokemonType: Codable {
    let type: NamedAPIResource
}

struct PokemonStat: Codable {
    let base_stat: Int
    let stat: NamedAPIResource
}

struct PokemonAbility: Codable {
    let ability: NamedAPIResource
}

struct PokemonMove: Codable {
    let move: NamedAPIResource
}

struct NamedAPIResource: Codable {
    let name: String
    let url: String
}

struct PokemonDetail: Codable {
    let height: Int
    let weight: Int
    let base_experience: Int
    let types: [PokemonType]
    let stats: [PokemonStat]
    let abilities: [PokemonAbility]
    let habitat: NamedAPIResource?
    let moves: [PokemonMove]
}
