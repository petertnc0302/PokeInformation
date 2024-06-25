//
//  Pokemon.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 19/6/24.
//

import Foundation

struct PokemonResponse: Decodable {
    let results: [PokemonData]
}

struct PokemonData: Decodable {
    let name: String
    let url: String
}

struct Pokemon: Hashable, Decodable {
    let name: String
    let url: String
    let id: Int
    let imageUrl: String
    var height: Int?
    var weight: Int?
    var base_experience: Int?
    var types: [PokemonType]?
    var stats: [PokemonStat]?
    var abilities: [PokemonAbility]?
    var habitat: NamedAPIResource?
    var moves: [PokemonMove]?
    
    init(name: String, url: String, id: Int, imageUrl: String) {
        self.name = name
        self.url = url
        self.id = id
        self.imageUrl = imageUrl
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id
    }
}
