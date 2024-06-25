//
//  BaseCollectionViewController.swift
//  PokeInformation
//
//  Created by Nguyen Cuong on 23/6/24.
//

import UIKit


class TagCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TagCollectionViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .gray
        contentView.layer.cornerRadius = 5
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}

class TagListView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!
    private var tags: [String] = []
    
    var tagBackgroundColor: UIColor = UIColor.gray {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var textColor: UIColor = .white {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var marginX: CGFloat = 5 {
        didSet {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    var marginY: CGFloat = 5 {
        didSet {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = marginX
        layout.minimumLineSpacing = marginY
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .blue
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.reuseIdentifier)
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    func addListTag(_ list: [String]) {
        tags.append(contentsOf: list)
        updateCollectionViewHeight()
    }
    
    func removeAllTags() {
        tags.removeAll()
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reuseIdentifier, for: indexPath) as! TagCollectionViewCell
        let tag = tags[indexPath.item]
        cell.titleLabel.text = tag
        cell.titleLabel.backgroundColor = tagBackgroundColor
        cell.titleLabel.textColor = textColor
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = tags[indexPath.item]
        let font = UIFont.systemFont(ofSize: 12)
        let tagWidth = (tag as NSString).size(withAttributes: [NSAttributedString.Key.font: font]).width + 20 // Add padding
        return CGSize(width: tagWidth, height: 30)
    }
    
    private func calculateCollectionViewHeight() -> CGFloat {
        let cellHeight: CGFloat = 30 // Chiều cao mỗi cell
        let marginY: CGFloat = 5 // Khoảng cách giữa các hàng
        let numberOfRows = ceil(CGFloat(tags.count) / 3.0) // Số hàng được tính dựa trên số lượng tag và số lượng tag trên mỗi hàng
        
        let totalHeight = numberOfRows * (cellHeight + marginY) - marginY // Tính tổng chiều cao
        
        return totalHeight
    }
    
    private func updateCollectionViewHeight() {
        let collectionViewHeight = calculateCollectionViewHeight()
        collectionView.frame.size.height = collectionViewHeight
        collectionView.reloadData() // Cập nhật lại dữ liệu khi thay đổi chiều cao
    }
}
