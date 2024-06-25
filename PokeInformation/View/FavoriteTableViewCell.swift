//
//  FavoriteTableViewCell.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 24/6/24.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageViewPokemon: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    
    var imageUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.nameLabel.textColor = .white
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.idLabel.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    func setColor(type: String?) {
        self.contentView.backgroundColor = UIColor.backgroundType(type: type)
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
