//
//  PokemonCollectionViewCell.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 19/6/24.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    
    var imageUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.nameLabel.textColor = .white
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.idLabel.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    func setColor(type: String?) {
        self.layer.backgroundColor = UIColor.backgroundType(type: type).cgColor
    }
    
    func configure(with imageUrl: String) {
        self.imageUrl = imageUrl
        if let image = URL(string: imageUrl) {
            imageView?.setImage(with: image)
        } else {
            imageView?.image = UIImage(named: "logo")
        }
    }
}

