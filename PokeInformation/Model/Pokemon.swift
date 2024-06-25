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

extension Pokemon {
    init(entity: FavoritePokemon) {
        self.name = entity.name ?? ""
        self.url = ""
        self.id = Int(entity.id)
        self.imageUrl = entity.imageUrl ?? ""
        self.height = Int(entity.height)
        self.weight = Int(entity.weight)
        self.base_experience = Int(entity.base_experience)

        if let typesData = entity.types {
            self.types = try? JSONDecoder().decode([PokemonType].self, from: typesData)
        }

        if let statsData = entity.stats {
            self.stats = try? JSONDecoder().decode([PokemonStat].self, from: statsData)
        }

        if let abilitiesData = entity.abilities {
            self.abilities = try? JSONDecoder().decode([PokemonAbility].self, from: abilitiesData)
        }
        
        if let habitatData = entity.habitat {
            self.habitat = try? JSONDecoder().decode(NamedAPIResource.self, from: habitatData)
        }
        
        if let movesData = entity.moves {
            self.moves = try? JSONDecoder().decode([PokemonMove].self, from: movesData)
        }
    }
}
