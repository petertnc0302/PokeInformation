//
//  PokemonViewController.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 21/6/24.
//

import UIKit

class FavoriteViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, LoadingIndicatorPresenter {
    @IBOutlet weak var tableView: UITableView!
    private var favoritePokemons: [FavoritePokemon] = []
    let cellSpacingHeight: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadFavorites()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavorites), name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadFavorites() {
        loadFavorites()
        tableView.reloadData()
    }
    
    private func loadFavorites() {
        favoritePokemons = FavoriteManager.shared.getFavorites()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
        let pokemon = favoritePokemons[indexPath.row]
        cell.nameLabel.text = pokemon.name.uppercased()
        cell.idLabel.text = String(format: "#%03d", pokemon.id)
        cell.setColor(type: pokemon.types?.first?.type.name)
        cell.configure(with: pokemon.imageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemonFavorite = favoritePokemons[indexPath.row]
        var pokemon = Pokemon(name: pokemonFavorite.name, url: pokemonFavorite.url, id: pokemonFavorite.id, imageUrl: pokemonFavorite.imageUrl)
        pokemon.height = pokemonFavorite.height
        pokemon.weight = pokemonFavorite.weight
        pokemon.base_experience = pokemonFavorite.base_experience
        pokemon.types = pokemonFavorite.types
        pokemon.stats = pokemonFavorite.stats
        pokemon.abilities = pokemonFavorite.abilities
        pokemon.habitat = pokemonFavorite.habitat
        pokemon.moves = pokemonFavorite.moves
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as! PokemonDetailViewController
        secondViewController.pokemon = pokemon
        self.navigationController?.pushViewController(secondViewController, animated: true)
        hideTabBar()

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pokemonFavorite = favoritePokemons[indexPath.row]
            FavoriteManager.shared.removeFavorite(pokemonFavorite)
            reloadFavorites()
        }
    }
}
