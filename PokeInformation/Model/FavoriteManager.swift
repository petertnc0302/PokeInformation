//
//  FavoriteManager.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 24/6/24.
//

import CoreData
import UIKit

class FavoriteManager {
    static let shared = FavoriteManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // Lưu một Pokemon vào danh sách yêu thích
    func addPokemonToFavorites(pokemon: Pokemon) {
        let entity = FavoritePokemon(context: context)
        entity.name = pokemon.name
        entity.id = Int32(pokemon.id)
        entity.imageUrl = pokemon.imageUrl
        entity.height = Int32(pokemon.height ?? 0)
        entity.weight = Int32(pokemon.weight ?? 0)
        entity.base_experience = Int32(pokemon.base_experience ?? 0)
        if let types = try? JSONEncoder().encode(pokemon.types) {
            entity.types = types
        }

        if let stats = try? JSONEncoder().encode(pokemon.stats) {
            entity.stats = stats
        }

        if let abilities = try? JSONEncoder().encode(pokemon.abilities) {
            entity.abilities = abilities
        }

        if let habitat = try? JSONEncoder().encode(pokemon.habitat) {
            entity.habitat = habitat
        }

        if let moves = try? JSONEncoder().encode(pokemon.moves) {
            entity.moves = moves
        }

        saveContext()
    }

    // Xóa một Pokemon khỏi danh sách yêu thích
    func removePokemonFromFavorites(pokemon: FavoritePokemon) {
        context.delete(pokemon)
        saveContext()
    }

    // Kiểm tra xem một Pokemon có trong danh sách yêu thích hay không
    func isFavorite(pokemon: Pokemon) -> Bool {
        let fetchRequest: NSFetchRequest<FavoritePokemon> = FavoritePokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", pokemon.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.count > 0
        } catch {
            print("Lỗi khi kiểm tra Pokemon yêu thích: \(error)")
            return false
        }
    }

    // Lấy tất cả Pokemon yêu thích
    func getAllFavorites() -> [FavoritePokemon] {
        let fetchRequest: NSFetchRequest<FavoritePokemon> = FavoritePokemon.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Lỗi khi lấy Pokemon yêu thích: \(error)")
            return []
        }
    }

    // Lưu context
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

