//
//  FavoriteManager.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 24/6/24.
//

import Foundation

import Foundation

class FavoriteManager {
    static let shared = FavoriteManager()
    
    private var favorites: [FavoritePokemon] = []
    
    private init() {
        loadFavorites()
    }
    
    func addFavorite(_ pokemon: FavoritePokemon) {
        if !favorites.contains(pokemon) {
            favorites.append(pokemon)
            saveFavorites()
        }
    }
    
    func removeFavorite(_ pokemon: FavoritePokemon) {
        if let index = favorites.firstIndex(of: pokemon) {
            favorites.remove(at: index)
            saveFavorites()
        }
    }
    
    func isFavorite(_ pokemon: FavoritePokemon) -> Bool {
        return favorites.contains(pokemon)
    }
    
    func getFavorites() -> [FavoritePokemon] {
        return favorites
    }
    
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: "favoritePokemons")
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favoritePokemons"),
           let savedFavorites = try? JSONDecoder().decode([FavoritePokemon].self, from: data) {
            favorites = savedFavorites
        }
    }
}
