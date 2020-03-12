//
//  CategoryCollectionCell.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-01.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//


import UIKit


class CategoryCollectionCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var delegate: CollectionViewCellDelegate?
    
    public let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        return collectionView
    }()

      
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCollectionView()
        
    }
    
    func setupCollectionView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(BrowseByCategoryCell.self, forCellWithReuseIdentifier: "collectionCell")
        
        self.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive  = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell =  collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)as! BrowseByCategoryCell
        
        switch indexPath.row {
        case 0:
            categoryCell.backgroundColor = .systemGreen
            categoryCell.categoryTitle.text = "Home"
            categoryCell.iconCategory.image = UIImage(named: "simpleHomeIcon")
        case 1:
            categoryCell.backgroundColor = .systemBlue
            categoryCell.categoryTitle.text = "Car"
            categoryCell.iconCategory.image = UIImage(named: "simpleCarIcon")
        case 2:
            categoryCell.backgroundColor = .systemPink
            categoryCell.categoryTitle.text = "Parlor"
            categoryCell.iconCategory.image = UIImage(named: "simpleShopIcon")
        case 3:
            categoryCell.backgroundColor = .systemYellow
            categoryCell.categoryTitle.text = "Other"
            categoryCell.iconCategory.image = UIImage(named: "simpleMenuIcon")
        default:
            break
        }
        
        return categoryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedCategory(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((self.collectionView.frame.width/2) - 30), height: 100)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

