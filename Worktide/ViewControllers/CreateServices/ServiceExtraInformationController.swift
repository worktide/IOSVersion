//
//  ServiceDescriptionController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-04.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit

class ServiceExtraInformationController:UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextViewDelegate{
    
    var delegate: ChangeServiceDelegate?
    var fromChangeService = false
    
    var imageArray = [UIImage]()
    var createServiceModel:CreateServiceModel!
    
    //IOS Funtions------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigation()
        setupCollectionView()
    }
    
    //SetupView------------------------------------------------------------------------
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .never
        title = "Extra Information"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(menuButtonTapped))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    //TableView----------------------------------------------------------------------
    
    func setupCollectionView(){
        collectionView.backgroundColor = .white
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.contentInset = insets
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CreateServiceExtraInfoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ControllerHeader")
        collectionView.register(ImagesCell.self, forCellWithReuseIdentifier: "ImagesCell")
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required, // Width is fixed
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ControllerHeader", for: indexPath) as! CreateServiceExtraInfoHeader
        headerView.descriptionTextView.delegate = self
        headerView.noteToCustomerTextView.delegate = self
        
        headerView.descriptionTextView.text = createServiceModel.serviceDescription
        headerView.noteToCustomerTextView.text = createServiceModel.noteToCustomer
        
        if !headerView.descriptionTextView.text.isEmpty {
            headerView.descriptionPlaceHolder.isHidden = true
        }
        
        if !headerView.noteToCustomerTextView.text.isEmpty {
            headerView.noteToCustomerPlaceHolder.isHidden = true
        }
        
        headerView.addImagesButton.addTapGestureRecognizer{
            ImagePickerManager().pickImage(self){ image in
                self.imageArray.append(image)
                self.updateCollectionView()
            }
            
            
        }
        return headerView

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath as IndexPath) as! ImagesCell
        cell.imageView.image = imageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let actionAlert = UIAlertController(title: "Delete image?", message: nil, preferredStyle: .alert)

        actionAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.imageArray.remove(at: indexPath.row)
            self.updateCollectionView()
          }))

        actionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          }))

        self.present(actionAlert, animated: true, completion: nil)
        
    }
    
    func updateCollectionView() {
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }
    
    
    //TextView------------------------------------------------------------------------
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //300 chars restriction
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return textView.text.count + (text.count - range.length) <= 250
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0)) as! CreateServiceExtraInfoHeader
        
        switch textView {
        case header.descriptionTextView:
            createServiceModel.serviceDescription = header.descriptionTextView.text
            if(textView.text.count == 0){
                header.descriptionPlaceHolder.isHidden = false
            } else {
                header.descriptionPlaceHolder.isHidden = true
        }
        default:
            createServiceModel.noteToCustomer = header.noteToCustomerTextView.text
            if(textView.text.count == 0){
                header.noteToCustomerPlaceHolder.isHidden = false
             } else {
                header.noteToCustomerPlaceHolder.isHidden = true
            }
        }
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //Listeners------------------------------------------------------------------------
    
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            self.view.endEditing(true)
            if(fromChangeService){
                /*if(descriptionTextView.text.count != 0){
                    delegate?.changeServiceDescription(value: descriptionTextView.text)
                }
                self.dismiss(animated: true, completion: nil)*/
                
            } else {
                let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0)) as! CreateServiceExtraInfoHeader
                createServiceModel.serviceDescription = header.descriptionTextView.text
                createServiceModel.noteToCustomer = header.noteToCustomerTextView.text
                createServiceModel.serviceImages = imageArray
                
                if header.descriptionTextView.text.isEmpty {
                    header.descriptionPlaceHolder.textColor = .red
                } else {
                    let viewController = ReviewNewServiceController()
                    viewController.createServiceModel = createServiceModel!
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            
        default:
            break
        }
    }
    
    
}

class CreateServiceExtraInfoHeader:UICollectionReusableView{
    
    //Item Initialization------------------------------------------------------------------------

     private let descriptionLabel:UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.text = "Service Description"
         label.textColor = .black
         label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
         label.adjustsFontSizeToFitWidth = true
         return label
     }()
     
     private let descriptionDescription:UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.text = "Explain what your service is all about. Use this chance to seperate yourself from the rest."
         label.textColor = .black
         label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
         label.numberOfLines = 0
         return label
     }()
     
     public let descriptionTextView:UITextView = {
         let textView = UITextView()
         textView.translatesAutoresizingMaskIntoConstraints = false
         textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
         textView.textColor = .black
         textView.layer.borderWidth = 0.5
         textView.layer.borderColor = UIColor.darkGray.cgColor
         textView.layer.cornerRadius = 10
         return textView
     }()
     
     public let descriptionPlaceHolder:UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
         label.numberOfLines = 0
         label.textColor = .lightGray
         label.text = "250 characters max"
         label.isUserInteractionEnabled = false
         return label
     }()
     
     private let noteToCustomerLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Note for customer"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
        }()
        
    private let noteToCustomerDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Use this to let the customer know where to meet, what they need, and any additional information they need."
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.numberOfLines = 0
        return label
     }()
     
     public let noteToCustomerTextView:UITextView = {
         let textView = UITextView()
         textView.translatesAutoresizingMaskIntoConstraints = false
         textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
         textView.textColor = .black
         textView.layer.borderWidth = 0.5
         textView.layer.borderColor = UIColor.darkGray.cgColor
         textView.layer.cornerRadius = 10
         return textView
     }()
     
     public let noteToCustomerPlaceHolder:UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
         label.numberOfLines = 0
         label.textColor = .lightGray
         label.text = "250 characters max (optional)"
         label.isUserInteractionEnabled = false
         return label
     }()
     
     private let imagesLabel:UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.text = "Service Images"
         label.textColor = .black
         label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
         label.adjustsFontSizeToFitWidth = true
         return label
     }()
         
     private let imagesDescription:UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.text = "People are more likely to book services that have photos in them, don't worry you can always add more later."
         label.textColor = .black
         label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
         label.numberOfLines = 0
         return label
      }()
    
    public let addImagesButton:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.text = "Add Images"
        label.textColor = .systemBlue
        label.textAlignment = .right
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    func setupView(){
        
        ///service description-----------------------
        
        self.addSubview(descriptionLabel)
        self.addSubview(descriptionDescription)
        self.addSubview(descriptionTextView)
        self.addSubview(descriptionPlaceHolder)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
        descriptionDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        descriptionDescription.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        descriptionDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
        descriptionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: descriptionDescription.bottomAnchor, constant: 20).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5);
        
        descriptionPlaceHolder.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 10).isActive = true
        descriptionPlaceHolder.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor, constant: -10).isActive = true
        descriptionPlaceHolder.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 10).isActive = true
        
        ///Note to customer views--------------------------
        
        self.addSubview(noteToCustomerLabel)
        self.addSubview(noteToCustomerDescription)
        self.addSubview(noteToCustomerTextView)
        self.addSubview(noteToCustomerPlaceHolder)
        
        noteToCustomerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        noteToCustomerLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 30).isActive = true
        noteToCustomerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
        noteToCustomerDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        noteToCustomerDescription.topAnchor.constraint(equalTo: noteToCustomerLabel.bottomAnchor, constant: 10).isActive = true
        noteToCustomerDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
        
        noteToCustomerTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        noteToCustomerTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        noteToCustomerTextView.topAnchor.constraint(equalTo: noteToCustomerDescription.bottomAnchor, constant: 20).isActive = true
        noteToCustomerTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        noteToCustomerTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5);
        
        noteToCustomerPlaceHolder.leadingAnchor.constraint(equalTo: noteToCustomerTextView.leadingAnchor, constant: 10).isActive = true
        noteToCustomerPlaceHolder.trailingAnchor.constraint(equalTo: noteToCustomerTextView.trailingAnchor, constant: -10).isActive = true
        noteToCustomerPlaceHolder.topAnchor.constraint(equalTo: noteToCustomerTextView.topAnchor, constant: 10).isActive = true
        
        ///add images-------------------------
        
        self.addSubview(imagesLabel)
        self.addSubview(imagesDescription)
        self.addSubview(addImagesButton)
        
        addImagesButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -25).isActive = true
        addImagesButton.centerYAnchor.constraint(equalTo: imagesLabel.centerYAnchor).isActive = true
        
        imagesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        imagesLabel.topAnchor.constraint(equalTo: noteToCustomerTextView.bottomAnchor, constant: 30).isActive = true
        imagesLabel.trailingAnchor.constraint(equalTo: addImagesButton.leadingAnchor, constant: -15).isActive = true
        
        imagesDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        imagesDescription.topAnchor.constraint(equalTo: imagesLabel.bottomAnchor, constant: 10).isActive = true
        imagesDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
        
        //ADD TO LAST VIEW
        imagesDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
