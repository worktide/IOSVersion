//
//  AddImagesController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-06.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AddImagesController:UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var imageArray = [ImageModel]()
    var serviceID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigation()
        getData()
    }
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .always
        title = "Service Photos"
    }
    
    func setupCollectionView(){
        
        let inset = UIEdgeInsets(top: 25, left: 2, bottom: 80, right: 2)
        collectionView.contentInset = inset
        
        collectionView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        collectionView.delegate = self
        collectionView.register(AddImagesCell.self, forCellWithReuseIdentifier: "MyServicesCell")
        collectionView.register(ImagesCell.self, forCellWithReuseIdentifier: "ImagesCell")
        
        
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count + 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyServicesCell", for: indexPath) as! AddImagesCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
            let model = imageArray[indexPath.row - 1]
            cell.imageView.image = model.image
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            ImagePickerManager().pickImage(self){ image in
                self.showSpinner(onView: self.view)
                
                self.uploadImageToFirebase(image: image)
            }
        default:
            self.showActionSheet(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0 - 8
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    
    
    func getData(){
        self.showSpinner(onView: self.view)
        let db = Firestore.firestore()
        db.collection("Services").document(serviceID).getDocument { (document, error) in
            if let document = document, document.exists {
                self.imageArray = [ImageModel]()
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
                        
                        self.removeSpinner()
                    }
                }
                
                if (imagesArrayID?.count == 0 || imagesArrayID == nil){
                    self.removeSpinner()
                }
                
            } else {
                self.removeSpinner()
                print("Document does not exist")
            }
        }

    }
    
    
    
    func updateCollectionView () {
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }
    
    func uploadImageToFirebase(image:UIImage){
        
        let storageRef = Storage.storage().reference().child("servicePhotos").child(serviceID).child("\(randomString(length: 12)).jpg")
        
        storageRef.putData((image.resizeWithWidth(width: 1000)?.pngData())!, metadata: nil, completion: { (metadata, error) in

            self.removeSpinner()
                
            // Fetch the download URL
            storageRef.downloadURL { url, error in
                if error != nil {
                    // Handle any errors
                    self.showImageError()
                    
                } else {
                    let urlString:String = (url?.absoluteString) ?? ""
                    let db = Firestore.firestore()
                    db.collection("Services").document(self.serviceID).updateData([
                        "servicePhotos": FieldValue.arrayUnion([urlString])
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            self.imageArray.append(ImageModel(image: image, imageString: urlString))
                            self.updateCollectionView()
                        }
                    }
                }
            }
        })
        

    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func showImageError() {
        let alert = UIAlertController(title: "There was a problem", message: "Please upload your image again later.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    func showActionSheet(_ indexPath:IndexPath){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete Image", style: .default, handler: { (_) in
            
            let model = self.imageArray[indexPath.row - 1]
            
            let db = Firestore.firestore()
            db.collection("Services").document(self.serviceID).updateData([
                "servicePhotos": FieldValue.arrayRemove([model.imageString!])
            ]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    self.imageArray.remove(at: indexPath.row - 1)
                    self.updateCollectionView()
                }
            }
            
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
}
