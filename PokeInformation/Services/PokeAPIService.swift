//
//  PokeAPIService.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 19/6/24.
//

import Foundation

class PokeAPIService {
    enum Endpoints {
        static let base = "https://pokeapi.co/api/v2"
        static let baseImage = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"
        case getPokemons(Int)
        
        var urlString: String {
            switch self {
            case .getPokemons(let page):
                return "\(Endpoints.base)/pokemon?offset=\((page - 1) * 20)&limit=20"
            }
        }
        
        var url: URL {
            return URL(string: urlString)!
        }
    }
    
    func fetchPokemons(page: Int, completion: @escaping ([Pokemon]) -> Void) {
        let url = Endpoints.getPokemons(page).url
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                    let pokemons = result.results.map { pokemonData -> Pokemon in
                        let name = pokemonData.name
                        let urlPokemon = pokemonData.url
                        let id = getIdFromUrl(urlPokemon)
                        return Pokemon(name: name.capitalized, id: id, imageUrl: "\(Endpoints.baseImage)\(String(id)).png")
                    }
                    DispatchQueue.main.async {
                        completion(pokemons)
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}
