//
//  TimeSelectServiceController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-18.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class TimeSelectServiceController: UICollectionViewController, UICollectionViewDelegateFlowLayout{

    var userID:String!
    var serviceDuration:Int!
    var dateChosen:Date!
    var location:CLLocationCoordinate2D!
    
    var timeAvailableArray = [String]()
    var timeTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    func setupCollectionView(){
        
        let inset = UIEdgeInsets(top: 25, left: 25, bottom: 80, right: 25)
        collectionView.contentInset = inset
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(TimeAvailabilityCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(CollectionViewHeaderCell.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionTitleHeader")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        timeAvailableArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TimeAvailabilityCell
        let model = timeAvailableArray[indexPath.row]
        cell.timeLabel.text = model.description
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/3 - 20, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableview = UICollectionReusableView()
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            //FOR HEADER VIEWS
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionTitleHeader", for: indexPath) as! CollectionViewHeaderCell

            headerView.messageBoardText.text = timeTitle
            headerView.backgroundColor = .white
            return headerView
        default:
            return reusableview
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = timeAvailableArray[indexPath.row]
        
        BookServiceDetails.details.serviceDate = timeTitle + " at " + model.description
        
        let viewController = ConfirmAppointmentController()
        viewController.timeChosen = model.description
        viewController.userID = userID
        viewController.serviceDuration = serviceDuration
        viewController.dateChosen = dateChosen
        viewController.location = location
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
}
