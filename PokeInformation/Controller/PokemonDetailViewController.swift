//
//  PokemonDetailViewController.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 21/6/24.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var typeStackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    
    var pokemon: Pokemon?
    
    private lazy var firstViewController: InformationViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController
        viewController.pokemon = pokemon
        self.add(asChildViewController: viewController)

        return viewController
    }()

    private lazy var secondViewController: StatsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        var viewController = storyboard.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController
        viewController.pokemon = pokemon
        self.add(asChildViewController: viewController)

        return viewController
    }()
    
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: secondViewController)
            add(asChildViewController: firstViewController)
        } else {
            remove(asChildViewController: firstViewController)
            add(asChildViewController: secondViewController)
        }
    }

    func setupView() {
        updateView()
    }

    static func viewController() -> PokemonDetailViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PokemonDetailViewController") as! PokemonDetailViewController
    }
    
    private func add(asChildViewController viewController: UIViewController) {

        addChild(viewController)

        containerView.addSubview(viewController.view)

        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        viewController.didMove(toParent: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFavoriteButton()
        if let pokemon = pokemon {
            navigationItem.title = pokemon.name.capitalized
            headerView.backgroundColor = UIColor.backgroundType(type: pokemon.types?.first?.type.name).withAlphaComponent(0.3)
            let backgroundImage = UIImage(named: "pokeball")
            let blurredImage = backgroundImage?.applyBlur(radius: 10)?.maskWithColor(color: .white)
            headerView.layer.contents = blurredImage?.cgImage
            headerView.layer.contentsGravity = .resizeAspect
            headerView.roundCorners([.bottomLeft, .bottomRight], radius: 20)
            imageView.setImage(with: URL(string: pokemon.imageUrl))
            typeStackView.spacing = 8
            headerView.roundCorners([.bottomLeft, .bottomRight], radius: 20)
            addLabels(to: typeStackView, withTexts: pokemon.types?.map { $0.type.name })
        }
        self.setupView()
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        updateView()
    }
    
    func addLabels(to stackView: UIStackView, withTexts texts: [String]?) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if ((texts?.isEmpty) != nil) {
            for text in texts! {
                let label = CustomLabel()
                label.configure(withText: text.capitalized, backgroundColor: UIColor.backgroundType(type: text))
                stackView.addArrangedSubview(label)
            }
            stackView.spacing = 8
            stackView.alignment = .center
        }
    }
    
    @IBAction func toggleFavorite(_ sender: Any) {
        guard let pokemon = pokemon else { return }
        let favorite = FavoritePokemon(
            id: pokemon.id,
            name: pokemon.name,
            imageUrl: pokemon.imageUrl,
            url: pokemon.url,
            height: pokemon.height,
            weight: pokemon.weight,
            base_experience: pokemon.base_experience,
            types: pokemon.types,
            stats: pokemon.stats,
            abilities: pokemon.abilities,
            habitat: pokemon.habitat,
            moves: pokemon.moves
        )
        if FavoriteManager.shared.isFavorite(favorite) {
            FavoriteManager.shared.removeFavorite(favorite)
        } else {
            FavoriteManager.shared.addFavorite(favorite)
        }
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        guard let pokemon = pokemon else { return }
        let favorite = FavoritePokemon(
            id: pokemon.id,
            name: pokemon.name,
            imageUrl: pokemon.imageUrl,
            url: pokemon.url,
            height: pokemon.height,
            weight: pokemon.weight,
            base_experience: pokemon.base_experience,
            types: pokemon.types,
            stats: pokemon.stats,
            abilities: pokemon.abilities,
            habitat: pokemon.habitat,
            moves: pokemon.moves
        )
        if FavoriteManager.shared.isFavorite(favorite) {
            favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteButton.image = UIImage(systemName: "heart")
        }
    }
}
