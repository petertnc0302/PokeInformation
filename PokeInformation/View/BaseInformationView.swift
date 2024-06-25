//
//  BaseInfoViewController.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 23/6/24.
//

import UIKit

class BaseInformationView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Base Information"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "HEIGHT"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let heightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "1.0 m"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "WEIGHT"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let weightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "13.0 kg"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let baseExpLabel: UILabel = {
        let label = UILabel()
        label.text = "BASE EXP."
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let baseExpValueLabel: UILabel = {
        let label = UILabel()
        label.text = "142"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        
        let heightStack = createInfoStack(titleLabel: heightLabel, valueLabel: heightValueLabel)
        let weightStack = createInfoStack(titleLabel: weightLabel, valueLabel: weightValueLabel)
        let baseExpStack = createInfoStack(titleLabel: baseExpLabel, valueLabel: baseExpValueLabel)

        let infoStackView = UIStackView(arrangedSubviews: [heightStack, weightStack, baseExpStack])
        infoStackView.axis = .horizontal
        infoStackView.alignment = .fill
        infoStackView.distribution = .fillEqually
        infoStackView.spacing = 16

        let mainStackView = UIStackView(arrangedSubviews: [titleLabel, infoStackView])
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.spacing = 8
        
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    private func createInfoStack(titleLabel: UILabel, valueLabel: UILabel) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }
}
