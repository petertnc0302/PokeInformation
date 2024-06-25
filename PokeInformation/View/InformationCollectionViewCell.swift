//
//  InformationViewCell.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 24/6/24.
//

import UIKit

class InformationCollectionViewCell: UICollectionViewCell {
    @IBOutlet var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
        self.backgroundColor = .systemGreen
        self.tagLabel.textColor = .white
    }
}
