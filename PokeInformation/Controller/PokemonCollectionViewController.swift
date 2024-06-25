//
//  ViewController.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 19/6/24.
//PokemonCollectionViewController

import UIKit

class PokemonCollectionViewController: BaseViewController, UINavigationControllerDelegate, LoadingIndicatorPresenter {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noFoundsLabel: UILabel!
    
    var activityIndicator = UIActivityIndicatorView()
    let searchController = UISearchController(searchResultsController: nil)
    
    var pokemons = [Pokemon]()
    var filteredPokemons = Set<Pokemon>()
    let pokeAPIService = PokeAPIService()
    
    var currentPage = 1
    var isFetching = false
    var selectedPokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Setup search bar
        setupSearchBar()
        
        // Setup Refresh Control
        setupRefreshControl()
        
        // Fetch Pokémon list from API
        fetchPokemons()
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        reload()
        refreshControl.endRefreshing()
    }
    
    func reload() {
        currentPage = 1
        pokemons.removeAll()
        filteredPokemons.removeAll()
        collectionView.reloadData()
        fetchPokemons()
    }
    
    private func fetchPokemons() {
        guard !isFetching else { return }
        isFetching = true
        
        showActivityIndicator()
        self.pokeAPIService.fetchPokemons(page: self.currentPage) { [weak self] pokemons, error  in
            self?.hideActivityIndicator()
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                    self?.isFetching = false
                }
                return
            }
            self?.pokemons.append(contentsOf: pokemons)
            self?.filteredPokemons.formUnion(pokemons)
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.isFetching = false
            }
        }
       
    }
    
    // MARK: - UISearchBar
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search Pokémon"
        searchBar.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension PokemonCollectionViewController: UICollectionViewDataSource {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPokemons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as! PokemonCollectionViewCell
        let index = filteredPokemons.index(filteredPokemons.startIndex, offsetBy: indexPath.item)

        let pokemon = filteredPokemons[index]
        cell.nameLabel.text = pokemon.name.uppercased()
        cell.idLabel.text = String(format: "#%03d", pokemon.id)
        cell.setColor(type: pokemon.types?.first?.type.name)
        cell.configure(with: pokemon.imageUrl)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == pokemons.count - 1 && !isFetching {
            currentPage += 1
            fetchPokemons()
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let index = filteredPokemons.index(filteredPokemons.startIndex, offsetBy: indexPath.item)
         selectedPokemon = filteredPokemons[index]
         let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as! PokemonDetailViewController
         secondViewController.pokemon = selectedPokemon
         self.navigationController?.pushViewController(secondViewController, animated: true)
         hideTabBar()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PokemonCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let collectionViewSize = collectionView.frame.size.width - padding
        
        let width = collectionViewSize / 2 - padding
        let height = width + 40 // Adjust the height based on your label and image size
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}

// MARK: - UISearchResultsUpdating

extension PokemonCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterContentForSearchText("")
        searchBar.resignFirstResponder()
        noFoundsLabel.isHidden = true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
        }
        searchBar.resignFirstResponder()
    }

    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            filteredPokemons = Set(pokemons)
        } else {
            filteredPokemons = Set(pokemons.filter { $0.name.range(of: searchText, options: .caseInsensitive) != nil })
            if filteredPokemons.isEmpty {
                noFoundsLabel.isHidden = false
            } else {
                noFoundsLabel.isHidden = true
            }
        }
        collectionView.reloadData()
    }
}
