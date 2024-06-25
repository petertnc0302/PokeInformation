//
//  UIImageView+Extension.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 25/6/24.
//

import SDWebImage

extension UIImageView {
    func setImage(with url: URL?) {
        self.sd_setImage(with: url, placeholderImage: UIImage(named: "logo"), options: [.retryFailed, .refreshCached], completed: nil)
    }
}
