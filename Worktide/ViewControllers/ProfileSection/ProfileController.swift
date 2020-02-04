//
//  ProfileController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-10-29.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SafariServices
import MessageUI
import MapKit

struct ViewControllerStruct {
    static var details: ViewControllerStruct = ViewControllerStruct()
    
    var pushToViewController = " "
}

class ProfileController:UICollectionViewController, UICollectionViewDelegateFlowLayout, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate{
    
    var messageLink:String?
    var message:String?
    
    var settingsModel = [SettingsOptionModel]()
    var myServicesModel = [ServiceModel]()
    var setTapRecognizer = false
    
    //profile
    var usersName = ". ."
    var usersPhoneNumber = " "
    var profileImage = UIImage()
    var ratingStarAmountText = " "
    
    private let notLoggedInImage:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "createServiceIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let notLoggedInText:UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.center
        textView.text = "Please make an account to create or book services."
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        textView.numberOfLines = 0
        return textView
    }()
    
    private let loginButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign in", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        addAuthStateChangeListener()
        checkIfAuthenticated()
        setupCollectionView()
        getData()
    }
    
    
    func setupNavigationBar(){
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menuIcon")!.withRenderingMode(.alwaysOriginal),style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
        
    }
    
    func setupView(){
        
        view.backgroundColor = .white
        
        view.addSubview(notLoggedInImage)
        notLoggedInImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        notLoggedInImage.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -80).isActive = true
        notLoggedInImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        notLoggedInImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(notLoggedInText)
        notLoggedInText.topAnchor.constraint(equalTo: notLoggedInImage.bottomAnchor,constant: 25).isActive = true
        notLoggedInText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        notLoggedInText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
        view.addSubview(loginButton)
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: notLoggedInText.bottomAnchor, constant: 25).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
    }
    
    func setupCollectionView(){
        
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
        collectionView.contentInset = inset
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(AccountSettingsCell.self, forCellWithReuseIdentifier: "AccountSettingsCell")
        collectionView.register(MyServicesCell.self, forCellWithReuseIdentifier: "MyServicesCell")
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProfileHeader")
        collectionView.register(AccountSettingsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AccountSettingsHeader")
        
        if let collectionViewFlowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewFlowLayout.minimumInteritemSpacing = 0
            collectionViewFlowLayout.minimumLineSpacing = 0
        }
        
        let allData = [SettingsOptionModel(optionsTitle: "Create a Service", optionsImage: "createServiceIcon"),
                       SettingsOptionModel(optionsTitle: "My Availability", optionsImage: "timeIcon"),
                       SettingsOptionModel(optionsTitle: "Share App", optionsImage: "shareIcon"),
                       SettingsOptionModel(optionsTitle: "Support", optionsImage: "supportIcon"),
                       SettingsOptionModel(optionsTitle: "Logout", optionsImage: "none")]
        
        settingsModel.append(contentsOf: allData)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if( indexPath.section == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyServicesCell", for: indexPath) as! MyServicesCell
            let servicesModel = myServicesModel[indexPath.row]
            cell.jobTitle.text = servicesModel.serviceTitle
            cell.servicePrice.text = "$" + servicesModel.servicePay!
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountSettingsCell", for: indexPath) as! AccountSettingsCell
            
            let category = settingsModel[indexPath.row]
            cell.settingsTitle.text = category.optionsTitle
            cell.settingsImage.image = UIImage(named: category.optionsImage!)
            
            switch indexPath.row {
            case 4:
                cell.settingsTitle.textColor = .red
            default:
                cell.settingsTitle.textColor = .black
            }
            
            return cell
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let item = myServicesModel[indexPath.row]
            
            let viewController = ChangeServiceInformationController()
            viewController.jobID = item.serviceID
            viewController.servicePay = item.servicePay
            viewController.serviceTitle = item.serviceTitle
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overFullScreen
            self.present(navigationController, animated: true)
            
        case 1:
            switch indexPath.row {
            case 0:
                if CLLocationManager.locationServicesEnabled() {
                     switch CLLocationManager.authorizationStatus() {
                        case .notDetermined, .restricted, .denied:
                            self.openEnableLocationController()
                        case .authorizedAlways, .authorizedWhenInUse:
                            let viewController = CreateServiceController()
                            let navigationController = UINavigationController(rootViewController: viewController)
                            navigationController.modalPresentationStyle = .overFullScreen
                            self.present(navigationController, animated: true)
                     @unknown default:
                        self.openEnableLocationController()
                    }
                    } else {
                    self.openEnableLocationController()
                }
                
            case 1:
                let viewController = DaysAvailabilityController()
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .overFullScreen
                self.present(navigationController, animated: true)
            case 2:
                shareApp()
            case 3:
                sendEmail()
            default:
                logout()
            }
        default:
            break
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return myServicesModel.count
        } else {
            return settingsModel.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        let reusableview = UICollectionReusableView()
        if (kind == UICollectionView.elementKindSectionHeader) {
            let section = indexPath.section
            switch (section) {
            case 0:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeader", for: indexPath) as! ProfileHeader
                
                    
                    //profile message board
                headerView.boardView1.addTapGestureRecognizer{
                        
                    let url = URL(string: self.messageLink!)
                    let svc = SFSafariViewController(url: url!)
                    self.present(svc, animated: true, completion: nil)
                }
                
                if(message == nil){
                    headerView.boardView1.isHidden = true
                } else {
                    headerView.messageBoardText.text = message?.replacingOccurrences(of: "\\n", with: "\n")
                    headerView.boardView1.isHidden = false
                }
                
                //set up profileImage
                if(profileImage == UIImage()){
                    headerView.userProfileImage.removeAllSubviews()
                    headerView.name = usersName
                } else {
                    headerView.userProfileImage.removeAllSubviews()
                    headerView.userProfileImage.image = profileImage
                }
                
                //usersName
                headerView.usersNameText.text = usersName
                
                //set ratingstar
                headerView.ratingStarAmountText.text = ratingStarAmountText
                
                //set phone number
                headerView.usersPhoneNumber.text = usersPhoneNumber
                
                //Hide my services title if empty
                if(myServicesModel.count == 0){
                    headerView.accountSettingsTitle.isHidden = true
                } else {
                    headerView.accountSettingsTitle.isHidden = false
                }
                
                return headerView
            case 1:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AccountSettingsHeader", for: indexPath) as! AccountSettingsHeader
                return header
            default:
                return reusableview

            }
        }
        return reusableview
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required, // Width is fixed
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.section == 0){
            return CGSize(width: self.view.frame.width, height: 90)
        } else {
            return CGSize(width: self.view.frame.width, height: 60)
        }
    }
    
    
    
    func getData(){
        
        //GET USER DATA
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("Users").document(userID).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
        
            //get users name
            self.usersName = document.get("usersName") as? String ?? " "
            
            //get user profile picture
            let photoURL = document.get("userPhotoURL") as? String ?? "0"
            if(photoURL != "0"){
                let storageRef = Storage.storage().reference(forURL: photoURL)
                storageRef.getData(maxSize: 1000000/* 1mb */) { (data, error) -> Void in
                    if error != nil {
                        self.profileImage = UIImage()
                    } else {
                        self.profileImage = UIImage(data: data!)!
                        self.updateCollectionView()
                        
                    }
                }
            } else {
                self.profileImage = UIImage()
            }
            
            //average out the rating
            let averageRating = document.get("userRatingStar") as? [CGFloat] ?? [CGFloat]()
            if(averageRating.count > 3){
                self.ratingStarAmountText = String(Int(averageRating.reduce(0, +))/(averageRating.count))
            } else {
                
                self.ratingStarAmountText = "Not enough ratings"
                
            }
            
            //get user phoneNumber
            self.usersPhoneNumber = document.get("usersPhoneNumber") as? String ?? " "
            
            self.updateCollectionView()
        }
        
        //GET USERS SERVICES
        db.collection("Services").whereField("creatorID", isEqualTo: userID).addSnapshotListener { documentSnapshot, error in
           if let err = error {
                print("Error getting documents: \(err)")
            } else {
                self.myServicesModel.removeAll()
                for document in documentSnapshot!.documents {
                    let serviceTitle = document.get("serviceName") as! String
                    let servicePay = String(document.get("servicePay") as! Int)
                    let serviceID = document.documentID
                    
                    self.myServicesModel.append(ServiceModel(serviceTitle: serviceTitle, servicePay: servicePay, serviceID: serviceID))
                }
                self.updateCollectionView()
            }
            
            
        }
        
        
        //GET MESSAGEBOARDS
        let dbMessage = Firestore.firestore()
        dbMessage.collection("Misc").document("MessageBoards").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }

            self.messageLink = document.get("profileMessageLink") as? String
            self.message = document.get("profileMessage") as? String
            self.updateCollectionView()
        }
        
    }
    
    //Authentication Checks------------------------------------------------
    
    func addAuthStateChangeListener(){
        Auth.auth().addStateDidChangeListener { auth, user in
            self.checkIfAuthenticated()
        }
    }
    
    func checkIfAuthenticated(){
        if Auth.auth().currentUser == nil {
            ///user is not logged in
            self.collectionView.isHidden = true
            setupView()
            self.navigationItem.rightBarButtonItem = nil
        } else {
            getData()
            self.collectionView.isHidden = false
            for v in view.subviews{
                if(!(v is UICollectionView)){
                    v.removeFromSuperview()
                }
            }
            setupNavigationBar()
        }
    }

    
    
    //BUTTONS LISTENERS--------------------------------------------------
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            showProfileOptions()
        default:
            break
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
           switch sender {
           case loginButton:
               let viewController = LoginController()
               viewController.dismissViewController = true
               let navigationController = UINavigationController(rootViewController: viewController)
               navigationController.modalPresentationStyle = .overFullScreen
               self.present(navigationController, animated: true, completion: nil)
           default:
               break
           }
       }
       
    
    
    //DO FUNCTIONS--------------------------------------------------------------------
    
    func showProfileOptions(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Change picture", style: .default, handler: { (_) in
            ImagePickerManager().pickImage(self){ image in
                self.showSpinner(onView: self.view)
                
                self.uploadProfileImageToFirebase(image: image)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Change name", style: .default, handler: { (_) in
            self.changeName()
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openEnableLocationController(){
        let viewController = EnableLocationController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true)
    }
    
    private lazy var openCreateServiceController: Void = {
        let viewController = CreateServiceController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true)
    }()
    
    func changeName(){
        let alert = UIAlertController(title: "Change Name", message: nil, preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.autocapitalizationType = .words;
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            //self.usersNameText.text = textField!.text!
            
            if(textField?.text?.count != 0){
                guard let userID = Auth.auth().currentUser?.uid else { return }
                let db = Firestore.firestore()
                db.collection("Users").document(userID).updateData(["usersName": textField!.text!,])
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func uploadProfileImageToFirebase(image:UIImage){
        
        let userID = Auth.auth().currentUser!.uid
        let storageRef = Storage.storage().reference().child("usersPhoto").child("\(userID).jpg")
        
        storageRef.putData((image.resizeWithWidth(width: 150)?.pngData())!, metadata: nil, completion: { (metadata, error) in

            self.removeSpinner()
                
            // Fetch the download URL
            storageRef.downloadURL { url, error in
                if error != nil {
                    // Handle any errors
                    self.showImageError()
                    
                } else {
                        
                    let urlStr:String = (url?.absoluteString) ?? ""
                    let values = ["userPhotoURL": urlStr]
                    let db = Firestore.firestore()
                    db.collection("Users").document(userID).updateData(values as [String : AnyObject])
                }
            }
        })
        

    }
    
    func shareApp(){
        
       let message = "Worktide"
       //Set the link to share.
       if let link = NSURL(string: "https://apps.apple.com/ca/app/worktide/id1480167340"){
        let objectsToShare = [message,link] as [Any]
           let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        self.present(activityVC, animated: true, completion: nil)
       }
    }
    
    func showImageError() {
        let alert = UIAlertController(title: "There was a problem", message: "Please upload your image again later.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    func updateCollectionView () {
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }
    
    func logout(){
        let refreshAlert = UIAlertController(title: "Sign out", message: "You will have to login again.", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.changeRootView()
                UserDefaults.standard.set(nil, forKey: "usersAddress")
                
            }))

            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            }))

            present(refreshAlert, animated: true, completion: nil)
    }
    
    
    
    
    func changeRootView(){
        let viewController = BeforeLoginController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        window.rootViewController = navigationController
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion:
        { completed in
            do {
                try Auth.auth().signOut()
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                } catch let err {
                    print(err)
            }
        })
    }
    
    func sendEmail(){
    
        if !MFMailComposeViewController.canSendMail() {
            let viewController = SupportController()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overFullScreen
            self.present(navigationController, animated: true)
        } else {
            emailSetup()
        }
        
    }
    
    func emailSetup() {
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["worktide@outlook.com"])
        composeVC.setSubject("Worktide Support")
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }

    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
