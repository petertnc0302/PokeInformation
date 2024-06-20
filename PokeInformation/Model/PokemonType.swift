//
//  PokemonType.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 19/6/24.
//

import Foundation

struct PokemonType: Codable, Identifiable {
    let id = UUID()
    let name: String
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case name, url
    }
}

struct PokemonTypeResponse: Codable {
    let results: [PokemonType]
}
