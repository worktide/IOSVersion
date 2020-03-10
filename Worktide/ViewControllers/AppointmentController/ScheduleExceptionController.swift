//
//  AddTimeBlockController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-01.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ScheduleExceptionController:UIViewController{
    
    var viewToShow = 0
    var dateSelected:Date!
    
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    var dimView = UIView()
    var startTime = "09:00 AM"
    var endTime = "05:00 PM"
    var isFromStart = true
    
    private let imageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "appointmentIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Close all remaining spots on this day?"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let textLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Book Off", for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds =  false
        button.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 1.0
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    private let fromTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)!
        label.text = "From"
        label.textColor = .black
        return label
    }()
    
    private let fromTimeChosen: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("09:00 AM", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 1.0
        button.layer.masksToBounds =  false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 16)!
        return button
    }()
    
    private let toTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)!
        label.text = "To"
        label.textColor = .black
        return label
    }()
    
    private let toTimeChosen: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("05:00 PM", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 1.0
        button.layer.masksToBounds =  false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 16)!
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigation()
        
        switch viewToShow {
        case 0:
            setupBookingOffView()
        case 1:
            setupExtraWorkDayView()
        case 2:
            setupHourChange()
        default:
            break
        }
        
    }
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(menuButtonTapped))
    }
    
    func setupBookingOffView(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        textLabel.text = dateFormatter.string(from: dateSelected)
        
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 230).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25).isActive = true
        
        view.addSubview(textLabel)
        textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        
        view.addSubview(button)
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    func setupExtraWorkDayView(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        textLabel.text = dateFormatter.string(from: dateSelected)
        
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 230).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.image = UIImage(named: "calendarIcon")
        
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25).isActive = true
        titleLabel.text = "Open spots for this day?"
        
        view.addSubview(textLabel)
        textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        
        view.addSubview(button)
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.setTitle("Open Spots", for: .normal)
    }
    
    func setupHourChange(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE\nMMMM dd"
        titleLabel.text = dateFormatter.string(from: dateSelected)
        
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        
        view.addSubview(fromTitle)
        fromTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        fromTitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50).isActive = true
        
        view.addSubview(fromTimeChosen)
        fromTimeChosen.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        fromTimeChosen.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        fromTimeChosen.topAnchor.constraint(equalTo: fromTitle.bottomAnchor, constant: 10).isActive = true
        fromTimeChosen.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(toTitle)
        toTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        toTitle.topAnchor.constraint(equalTo: fromTimeChosen.bottomAnchor, constant: 25).isActive = true
        
        view.addSubview(toTimeChosen)
        toTimeChosen.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        toTimeChosen.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        toTimeChosen.topAnchor.constraint(equalTo: toTitle.bottomAnchor, constant: 10).isActive = true
        toTimeChosen.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(button)
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.setTitle("Save", for: .normal)
    }
    
    //Button listeners-------------------------------------------------------------
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case navigationItem.leftBarButtonItem:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    @objc func buttonAction(sender: UIButton) {

        switch sender {
        case fromTimeChosen:
            openTimePicker()
            self.isFromStart = true
        case toTimeChosen:
            self.isFromStart = false
            openTimePicker()
        default:
            let userID = Auth.auth().currentUser!.uid
            let db = Firestore.firestore()
            db.collection("Users").document(userID).collection("Exceptions").whereField("date", isEqualTo: dateSelected!).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        if let document = querySnapshot?.documents.first{
                            self.uploadData(documentID: document.documentID)
                        } else {
                            self.uploadData(documentID: nil)
                        }
                    }
            }
            
            
        }
        
        
    }
    
    //Do Functions------------------------------------------------------------------
    
    func uploadData(documentID:String?){
        let userID = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        
        //add data only if it doesnt exist else replace
        if(documentID == nil){
            switch viewToShow {
            case 0:
                HelperLoading.showLoading(message: "Saving", viewController: self)
                db.collection("Users").document(userID).collection("Exceptions").document().setData([
                    "date": dateSelected!,
                    "exceptionID": 0
                ]){ err in
                    if err != nil {
                        self.dismiss(animated: true, completion: {
                            HelperLoading.showUploadingFail(viewController:self)
                        })
                    } else {
                        self.dismiss(animated: true, completion: {
                            HelperLoading.showUploadingSuccessful(viewController:self)
                        })
                    }
                }
            case 1:
                view.removeAllSubviews()
                viewToShow = 2
                setupHourChange()
            case 2:
                HelperLoading.showLoading(message: "Saving", viewController: self)
                db.collection("Users").document(userID).collection("Exceptions").document().setData([
                    "date": dateSelected!,
                    "startTime": startTime,
                    "endTime": endTime,
                    "exceptionID": 1
                ], merge: true){ err in
                    if err != nil {
                        self.dismiss(animated: true, completion: {
                            HelperLoading.showUploadingFail(viewController:self)
                        })
                    } else {
                        self.dismiss(animated: true, completion: {
                            HelperLoading.showUploadingSuccessful(viewController:self)
                        })
                    }
                }
            default:
                break
            }
        } else {
            switch viewToShow {
            case 0:
                HelperLoading.showLoading(message: "Saving", viewController: self)
                db.collection("Users").document(userID).collection("Exceptions").document(documentID!).setData([
                    "date": dateSelected!,
                    "exceptionID": 0
                ]){ err in
                    if err != nil {
                        self.dismiss(animated: true, completion: {
                            HelperLoading.showUploadingFail(viewController:self)
                        })
                    } else {
                        self.dismiss(animated: true, completion: {
                            HelperLoading.showUploadingSuccessful(viewController:self)
                        })
                    }
                }
            case 1:
                view.removeAllSubviews()
                viewToShow = 2
                setupHourChange()
            case 2:
                HelperLoading.showLoading(message: "Saving", viewController: self)
                db.collection("Users").document(userID).collection("Exceptions").document(documentID!).setData([
                    "date": dateSelected!,
                    "startTime": startTime,
                    "endTime": endTime,
                    "exceptionID": 1
                ], merge: true){ err in
                    if err != nil {
                        self.dismiss(animated: true, completion: {
                            HelperLoading.showUploadingFail(viewController:self)
                        })
                    } else {
                        self.dismiss(animated: true, completion: {
                            HelperLoading.showUploadingSuccessful(viewController:self)
                        })
                    }
                }
            default:
                break
            }
        }
    }
    
    func openTimePicker(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "hh:mm a"
        
        datePicker = UIDatePicker.init()
        datePicker.backgroundColor = UIColor.white
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .time
        
        if(isFromStart){
            datePicker.date = dateFormatter.date(from: startTime)!
        } else {
            datePicker.date = dateFormatter.date(from: endTime)!
        }
        
        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        datePicker.alpha = 0
        self.view.addSubview(datePicker)
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneDateChosen(_:)))]
        toolBar.sizeToFit()
        toolBar.alpha = 0
        self.view.addSubview(toolBar)
        
        dimView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        dimView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 300)
        dimView.alpha = 0
        
        self.view.addSubview(dimView)
        
        UIView.animate(withDuration: 0.25) { () -> Void in
            self.dimView.alpha = 1.0
            self.datePicker.alpha = 1.0
            self.toolBar.alpha = 1.0
        }
    }
    
    @objc func doneDateChosen(_ sender: UIBarButtonItem) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.datePicker.alpha = 0
            self.toolBar.alpha = 0
            self.dimView.alpha = 0
        }, completion: {
            (value: Bool) in
            self.toolBar.removeFromSuperview()
            self.datePicker.removeFromSuperview()
            self.dimView.removeFromSuperview()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            
            //change data
            if(self.isFromStart){
                self.startTime = formatter.string(from: self.datePicker.date)
            } else {
                self.endTime = formatter.string(from: self.datePicker.date)
            }
            self.fromTimeChosen.setTitle(self.startTime, for: .normal)
            self.toTimeChosen.setTitle(self.endTime, for: .normal)
            
        })
        
    }
    
    
}
