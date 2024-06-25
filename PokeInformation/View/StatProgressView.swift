//
//  StatProgressView.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 24/6/24.
//

import UIKit

class StatProgressView: UIView {
    
    private let statLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .red
        progressView.trackTintColor = .lightGray.withAlphaComponent(0.5)
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        return progressView
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [statLabel, valueLabel, progressBar])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressBar.widthAnchor.constraint(equalToConstant: 200),
            progressBar.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func configure(stat: String, value: Int, color: UIColor) {
        statLabel.text = stat
        valueLabel.text = "\(value)"
        progressBar.progress = Float(value) / 100.0
        progressBar.progressTintColor = color
    }
}
