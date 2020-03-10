//
//  CreateServiceController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-10-31.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import MapKit

protocol ChangeServiceDelegate {
    func changeServiceLocation(latitude: Double, longitude:Double, circleDistance:CLLocationDistance)
    func changeServicePay(value: String)
    func changeServiceDuration(value: Int)
    func changeServiceDescription(value: String)
}

class CreateServiceController:UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var collectionViewIndex = 0
    
    private let prevBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Back", for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 16
        button.layer.masksToBounds =  false
        button.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 1.0
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)!
        return button
    }()
    
    private let doneBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Next", for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds =  false
        button.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 1.0
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)!
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViews()
        setupNavigation()
        
    }

    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(menuButtonTapped))
    }
    func setupViews(){
        view.backgroundColor = .white
        
        view.addSubview(prevBtn)
        prevBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        prevBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        prevBtn.widthAnchor.constraint(equalToConstant: 120).isActive = true
        prevBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(doneBtn)
        doneBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        doneBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        doneBtn.widthAnchor.constraint(equalToConstant: 120).isActive = true
        doneBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupCollectionView(){
        self.collectionView.isUserInteractionEnabled = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = true
        self.collectionView.register(CreateServiceIntroductionCell.self, forCellWithReuseIdentifier: "CreateServiceIntroductionCell")
        self.collectionView.backgroundColor = .white
        
        self.collectionView.frame = CGRect(x:0,y:0,width:self.view.frame.width, height:self.view.frame.height - 150)
        //self.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateServiceIntroductionCell", for: indexPath) as! CreateServiceIntroductionCell
        
        switch indexPath.row {
        case 0:
            cell.imageView.image = UIImage(named: "customersIcon")
            cell.headingLabel.text = "Find new customers"
            cell.descriptionLabel.text = "Let us do the hard work and get you new customers. We'll advertise for you so that you don't have to."
        case 1:
            cell.imageView.image = UIImage(named: "questionIcon")
            cell.headingLabel.text = "Set custom pricing"
            cell.descriptionLabel.text = "Ask questions for exactly what the customer want and set your pricing based on the customer's needs"
        default:
            cell.imageView.image = UIImage(named: "paymentIcon")
            cell.headingLabel.text = "Collect your payment"
            cell.descriptionLabel.text = "We are currently working on a payment system that is coming soon. Collect your own payments for now."
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    //Button listeners----------------------------------------------------------------------
    
    @objc func doneButton(sender: UIButton!) {
        
        switch sender {
        case doneBtn:
            switch collectionViewIndex {
            case 1:
                self.collectionView.scrollToNextItem()
                self.doneBtn.setTitle("Done", for: .normal)
            case 2:
                let viewController = NameServiceController()
                navigationController?.pushViewController(viewController, animated: true)
            default:
                self.collectionView.scrollToNextItem()
            }
            self.collectionViewIndex += 1
        default:
            if(collectionViewIndex > 0){
                self.collectionView.scrollToPreviousItem()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            self.collectionViewIndex -= 1
        }
        
        
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        let viewController = NameServiceController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}

class CreateServiceIntroductionCell: UICollectionViewCell {
    
    public let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let headingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    public let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.addSubview(imageView)
        self.addSubview(descriptionLabel)
        self.addSubview(headingLabel)
        
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.bottomAnchor.constraint(equalTo: headingLabel.topAnchor, constant: -20).isActive = true
        
        headingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
        self.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
