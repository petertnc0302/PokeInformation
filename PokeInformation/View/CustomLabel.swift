//
//  CustomLabel.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 23/6/24.
//

import UIKit

class CustomLabel: UILabel {
    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat
    
    override init(frame: CGRect) {
        self.topInset = 0
        self.bottomInset = 0
        self.leftInset = 12
        self.rightInset = 12
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.topInset = 0
        self.bottomInset = 0
        self.leftInset = 12
        self.rightInset = 12
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.textAlignment = .center
        self.textColor = .white
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.font = UIFont.boldSystemFont(ofSize: 16)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func configure(withText text: String, backgroundColor: UIColor) {
        self.text = text
        self.backgroundColor = backgroundColor
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
