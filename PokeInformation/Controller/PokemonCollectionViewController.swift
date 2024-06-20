//
//  ViewController.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 19/6/24.
//PokemonCollectionViewController

import UIKit

class PokemonCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = Set<Pokemon>()
    let pokeAPIService = PokeAPIService()
    
    var currentPage = 1
    var isFetching = false

    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Pokémon"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        super.viewDidLoad()
        
        self.title = "Danh sách Pokémon"
        
        collectionView.delegate = self
        collectionView.dataSource = self
                
        // Fetch Pokémon list from API
        guard !isFetching else {
            return
        }
        isFetching = true
        
        pokeAPIService.fetchPokemons (page: currentPage){ [weak self] pokemons in
            self?.pokemons = pokemons
            self?.filteredPokemons = Set(pokemons)
            self?.collectionView.reloadData()
            self?.isFetching = false
        }
        
        // Setup search bar
        setupSearchBar()
    }
    
    // MARK: - UISearchBar
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search Pokémon"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
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
        cell.nameLabel.text = pokemon.name.capitalized
        let imageUrl = URL(string: pokemon.imageUrl)!
        getData(from: imageUrl) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                cell.imageView.image = UIImage(data: data)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == pokemons.count - 1 && !isFetching {
            currentPage += 1
            pokeAPIService.fetchPokemons(page: currentPage) { [weak self] newPokemons in
                self?.pokemons.append(contentsOf: newPokemons)
                self?.filteredPokemons.formUnion(newPokemons)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
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
        // Xử lý thay đổi văn bản trong ô tìm kiếm
        filterContentForSearchText(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Xử lý khi người dùng bấm vào nút huỷ
        searchBar.text = ""
        filterContentForSearchText("")
        searchBar.resignFirstResponder() // Ẩn bàn phím
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Xử lý khi người dùng bấm vào nút tìm kiếm trên bàn phím
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
        }
        searchBar.resignFirstResponder() // Ẩn bàn phím
    }

    func filterContentForSearchText(_ searchText: String) {
        // Viết phương thức để lọc nội dung dựa trên searchText
        // Ví dụ:
        if searchText.isEmpty {
            filteredPokemons = Set(pokemons)
        } else {
            filteredPokemons = Set(pokemons.filter {
                $0.name.range(of: searchText, options: .caseInsensitive)
                != nil
            })
        }
        collectionView.reloadData()
    }
}
