//
//  AboutServiceController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-05.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import GoogleMaps
import MapKit

class AboutServiceController:UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var serviceID:String!
    var serviceDescription = ""
    var imageArray = [ImageModel]()
    
    var latitude:Double!
    var longitude:Double!
    var circleRadius:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCollectionView()
        getData()
        
    }
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        title = "About this service"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backIconBlack")!.withRenderingMode(.alwaysOriginal),style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
    }
    
    func setupCollectionView(){
        
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        collectionView.contentInset = inset
        
        collectionView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        collectionView.delegate = self
        
        
        
        
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 2:
            return imageArray.count
        default:
            return 1
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapViewCell", for: indexPath) as! MapViewCell
            cell.latitude = latitude
            cell.longitude = longitude
            cell.circleRadiusRange = circleRadius
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
            cell.imageView.image = imageArray[indexPath.row].image
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AboutServiceCell", for: indexPath) as! AboutServiceCell
            print(serviceDescription)
            if(serviceDescription == ""){
                cell.jobDesciption.text = "This user does not have a description for this service."
            } else {
                cell.jobDesciption.text = serviceDescription
            }
            return cell
        }
        
        
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            openMapForPlace()
        default:
            break
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableview = UICollectionReusableView()
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            //FOR HEADER VIEWS
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! TitleHeaders
            
            switch indexPath.section {
            case 1:
                headerView.messageBoardText.text = "Service Location"
            case 2:
                headerView.messageBoardText.text = "Photos"
            default:
                headerView.messageBoardText.text = ""
            }
            
            return headerView
        default:
            return reusableview
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: 0, height: 0)
        case 2:
            if(imageArray.count == 0){
                return CGSize(width: 0, height: 0)
            } else {
                let indexPath = IndexPath(row: 0, section: section)
                let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

                return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                          withHorizontalFittingPriority: .required, // Width is fixed
                                                          verticalFittingPriority: .fittingSizeLevel)
            }
        default:
            let indexPath = IndexPath(row: 0, section: section)
            let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

            return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                      withHorizontalFittingPriority: .required, // Width is fixed
                                                      verticalFittingPriority: .fittingSizeLevel)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.frame.width, height: 150)
        case 1:
            return CGSize(width: view.frame.width, height: 350)
        default:
            return CGSize(width: collectionView.bounds.width/3.0, height: collectionView.bounds.width/3.0)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func getData(){
        let db = Firestore.firestore()
        db.collection("Services").document(serviceID).getDocument { (document, error) in
            if let document = document, document.exists {
                let imagesArrayID = document.get("servicePhotos") as? [String]
                
                for imageID in imagesArrayID ?? [String](){
                    let storageRef = Storage.storage().reference(forURL: imageID)
                    storageRef.getData(maxSize: 10000000/* 10mb */) { (data, error) -> Void in
                        if error != nil {
                            print(error ?? "")
                        } else {
                            self.imageArray.append(ImageModel(image: UIImage(data: data!)!, imageString: imageID))
                            self.updateCollectionView()
                        }
                    }
                }
                
            } else {
                print("Document does not exist")
            }
        }

    }
    
    func updateCollectionView () {
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }
    
    
    
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.leftBarButtonItem:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    func openMapForPlace() {

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Service Location"
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    
}
