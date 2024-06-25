//
//  SecondViewController.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 22/6/24.
//

import UIKit

class StatsViewController: UIViewController {

    let scrollView = UIScrollView()
    let contentView = UIView()
    let stackView = UIStackView()
    
    var pokemon: Pokemon?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupStackView()
        configureData()
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupStackView() {
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    private func configureData() {
        guard let pokemon = pokemon else { return }
        
        let statsView = createStatsView(stats: pokemon.stats?.map { ($0.stat.name.uppercased(), $0.base_stat, getColor(for: $0.base_stat)) } ?? [])
        
        stackView.addArrangedSubview(statsView)
    }
    
    private func createStatsView(stats: [(String, Int, UIColor)]) -> UIView {
        let containerView = UIView()
        let titleLabel = UILabel()
        titleLabel.text = "Base stats"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .left

        let statsStackView = UIStackView()
        statsStackView.axis = .vertical
        statsStackView.alignment = .fill
        statsStackView.spacing = 8

        for (stat, value, color) in stats {
            let statView = StatProgressView()
            statView.configure(stat: stat, value: value, color: color)
            statsStackView.addArrangedSubview(statView)
        }

        let mainStackView = UIStackView(arrangedSubviews: [titleLabel, statsStackView])
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.spacing = 8

        containerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        return containerView
    }
    
    private func getColor(for num: Int) -> UIColor {
        if (num <= 25) {
            return .red
        } else if (num > 25 && num <= 50) {
            return .orange
        } else if (num > 50 && num <= 75) {
            return .yellow
        } else if (num > 75) {
            return .green
        } else {
            return .gray
        }
    }
}
