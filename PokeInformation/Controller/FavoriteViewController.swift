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
        favoritePokemons = FavoriteManager.shared.getAllFavorites()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
        let pokemonFavorite = favoritePokemons[indexPath.row]
        let pokemon = Pokemon(entity: pokemonFavorite)
        cell.nameLabel.text = pokemon.name.uppercased()
        cell.idLabel.text = String(format: "#%03d", pokemon.id)
        cell.setColor(type: pokemon.types?.first?.type.name)
        cell.configure(with: pokemon.imageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemonFavorite = favoritePokemons[indexPath.row]
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as! PokemonDetailViewController
        secondViewController.pokemon = Pokemon(entity: pokemonFavorite)
        self.navigationController?.pushViewController(secondViewController, animated: true)
        hideTabBar()

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pokemonFavorite = favoritePokemons[indexPath.row]
            FavoriteManager.shared.removePokemonFromFavorites(pokemon: pokemonFavorite)
            reloadFavorites()
        }
    }
}
