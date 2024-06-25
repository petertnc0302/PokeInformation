//
//  FirstViewController.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 22/6/24.
//

import UIKit

class InformationViewController: UIViewController {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var baseInformationView = BaseInformationView()
    private var datas = [[String]]()
    private var titles = [String]()

    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let pokemon = pokemon {
            configureView(with: pokemon)
        }
    }
    
    func configureView(with pokemon: Pokemon) {
        setupBaseInfoView(with: pokemon)
        setupCollectionView(with: pokemon)
    }
    
    func setupBaseInfoView(with pokemon: Pokemon) {
        baseInformationView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(baseInformationView)
        
        NSLayoutConstraint.activate([
            baseInformationView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 0),
            baseInformationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            baseInformationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            baseInformationView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        baseInformationView.heightValueLabel.text = "\(pokemon.height ?? 0) m"
        baseInformationView.weightValueLabel.text = "\(pokemon.weight ?? 0) kg"
        baseInformationView.baseExpValueLabel.text = "\(pokemon.base_experience ?? 0)"
    }
    
    func setupCollectionView(with pokemon: Pokemon) {
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = TagFlowLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 40)
        collectionView.collectionViewLayout = layout        
        if ((pokemon.habitat?.name.isEmpty) != nil) {
            var habitats = [String]()
            habitats.append(pokemon.habitat!.name)
            titles.append("Habitat")
            datas.append(habitats)
        }
        
        if ((pokemon.abilities?.isEmpty) != nil) {
            let abilities = pokemon.abilities?.map { $0.ability.name.capitalized } ?? []
            titles.append("Abilities")
            datas.append(abilities)
        }
        
        if ((pokemon.moves?.isEmpty) != nil) {
            let moves = pokemon.moves?.map { $0.move.name.capitalized } ?? []
            titles.append("Moves")
            datas.append(moves)
        }
    }
}

extension InformationViewController:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datas.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InformationCollectionViewCell", for: indexPath) as? InformationCollectionViewCell else {
            return InformationCollectionViewCell()
        }
        cell.tagLabel.text = datas[indexPath.section][indexPath.row]
        cell.tagLabel.preferredMaxLayoutWidth = collectionView.frame.width - 16
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? InformationCollectionViewCell, let _ = cell.tagLabel.text else {return}
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "InformationCollectionReusableView", for: indexPath) as? InformationCollectionReusableView {
                sectionHeader.tagHeaderLabel.text = "\(titles[indexPath.section])"
                return sectionHeader
            }
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 200, height: 30)
    }
}
