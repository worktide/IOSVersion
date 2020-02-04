//
//  AppointmentsViewController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-16.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FSCalendar

class AppointmentsViewController:UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var appointmentsArray = [AppointmentsModel]()
    
    private let notLoggedInImage:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "appointmentIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let notLoggedInText:UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.center
        textView.text = "Sign in so you can see your upcoming appointments"
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
        checkIfAuthenticated()
        addAuthStateChangeListener()
        setupNavigationBar()
        setupCollectionView()
    }
    
    func setupNavigationBar(){
        self.navigationItem.title = "Appointments"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose, target: self, action: #selector(menuButtonTapped(sender:)))
 
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
    
    //Collection View-----------------------------------------------------------------------------------
    
    func setupCollectionView(){
        
        let inset = UIEdgeInsets(top: 50, left: 0, bottom: 25, right: 0)
        collectionView.contentInset = inset
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        collectionView.register(SelectAppointmentCell.self, forCellWithReuseIdentifier: "SelectAppointmentCell")
        //collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProfileHeader")
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectAppointmentCell", for: indexPath) as! SelectAppointmentCell
            return cell
            
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: self.view.frame.width, height: 300)
        default:
            return CGSize(width: self.view.frame.width, height: 60)
        }
    }
    
    
    //Authentication Checks------------------------------------------------------------------------------
    func addAuthStateChangeListener(){
        Auth.auth().addStateDidChangeListener { auth, user in
            self.checkIfAuthenticated()
        }
    }
    
    func checkIfAuthenticated(){
        if Auth.auth().currentUser == nil {
            ///user is not logged in
            self.navigationItem.rightBarButtonItem = nil
            self.collectionView.isHidden = true
            setupView()
        } else {
            //getData()
            self.collectionView.isHidden = false
            for v in view.subviews{
                if(!(v is UICollectionView)){
                    v.removeFromSuperview()
                }
            }
            setupNavigationBar()
        }
    }
    
    //Button listeners--------------------------------------------------------------------------------------------
    
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
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            let viewController = AddTimeBlockController()
            self.present(viewController, animated:true)
        default:
            break
        }
    }
}

class CalendarCell:UICollectionViewCell{
    
    private let calendar:FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.appearance.titleDefaultColor = .lightGray
        calendar.today = nil
        calendar.placeholderType = .none
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)!
        return calendar
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.addSubview(calendar)
        calendar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        calendar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        calendar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
