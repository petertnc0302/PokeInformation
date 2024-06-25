//
//  PokeAPIService.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 19/6/24.
//

import Foundation
import UIKit

class PokeAPIService {
    enum Endpoints {
        static let base = "https://pokeapi.co/api/v2"
        static let baseImage = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"

        case getPokemons(Int)
        case getPokemonDetail(String)
        
        var urlString: String {
            switch self {
            case .getPokemons(let page):
                return "\(Endpoints.base)/pokemon?limit=20&offset=\((page-1) * 20)"
            case .getPokemonDetail(let name):
                return "\(Endpoints.base)/pokemon/\(name)"
            }
        }
        
        var url: URL {
            return URL(string: urlString)!
        }
    }
    
    func fetchPokemons(page: Int, completion: @escaping ([Pokemon], Error?) -> Void) {
        let url = Endpoints.getPokemons(page).url
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion([], error)
                return
            }
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(PokemonResponse.self, from: data)
                    var pokemons = result.results.map { pokemonData -> Pokemon in
                        let name = pokemonData.name
                        let urlPokemon = pokemonData.url
                        let id = getIdFromUrl(urlPokemon)
                        let pokemon = Pokemon(name: name.capitalized, url: urlPokemon, id: id, imageUrl: "\(Endpoints.baseImage)\(String(id)).png")
                        return pokemon
                    }
                    let group = DispatchGroup()
                    
                    for (index, _) in pokemons.enumerated() {
                        group.enter()
                        self.fetchPokemonDetail(url: pokemons[index].url) { (detail, error) in
                            if let detail = detail {
                                pokemons[index].height = detail.height
                                pokemons[index].weight = detail.weight
                                pokemons[index].base_experience = detail.base_experience
                                pokemons[index].types = detail.types
                                pokemons[index].stats = detail.stats
                                pokemons[index].abilities = detail.abilities
                                pokemons[index].habitat = detail.habitat
                                pokemons[index].moves = detail.moves
                            }
                            group.leave()
                        }
                    }
                    
                    group.notify(queue: .main) {
                        completion(pokemons, nil)
                    }
                } catch {
                    print("Error decoding data: \(error)")
                    completion([], error)
                }
            }
        }.resume()
    }
    
    func fetchPokemonDetail(url: String, completion: @escaping (PokemonDetail?, Error?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let detail = try JSONDecoder().decode(PokemonDetail.self, from: data)
                    completion(detail, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}
