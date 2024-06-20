//
//  Pokemon.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 19/6/24.
//

import Foundation

struct Pokemon: Hashable {
    let name: String
    let id: Int
    let imageUrl: String
    
    init(name: String,  id: Int, imageUrl: String) {
        self.name = name
        self.id = id
        self.imageUrl = imageUrl
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct PokemonListResponse: Codable {
    let results: [PokemonData]
    
    struct PokemonData: Codable {
        let name: String
        let url: String
    }
}

struct PokemonInfo: Codable {
    let id: Int
    let name: String
    let sprites: Sprites
    
    struct Sprites: Codable {
        let frontDefault: String
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
}
