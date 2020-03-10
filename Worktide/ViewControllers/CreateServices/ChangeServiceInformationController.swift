//
//  ChangeServiceInformationController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-18.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import MapKit
import FirebaseDynamicLinks

class ChangeServiceInformationController:UITableViewController, ChangeServiceDelegate{
    
    var jobID:String!
    var serviceTitle:String!
    var servicePay:String!
    
    var serviceDurationText = ""
    var serviceDuration = 0
    var minutes = 0
    var hour = 0
    
    var latitude:Double = 0
    var longitude:Double = 0
    var circleDistance:Double = 0
    
    var serviceDescription = ""
    
    private let containerLayout: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
        getData()
        
    }

    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        title = "Service Information"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backIconBlack")!.withRenderingMode(.alwaysOriginal),style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
    }
    
    func setupTableView(){
        
        self.tableView.register(ChangeServiceInfoCell.self, forCellReuseIdentifier: "buttonsCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let insets = UIEdgeInsets(top: 25, left: 0, bottom: 50, right: 0)
        self.tableView.contentInset = insets
        self.tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buttonsCell", for: indexPath) as! ChangeServiceInfoCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        switch indexPath.row {
        case 0:
            cell.textTitle.text = serviceTitle
            cell.textValue.text = ""
            cell.rightIcon.isHidden = true
        case 1:
            cell.textTitle.text = "Service price:"
            cell.textValue.text = "$" + servicePay
        case 2:
            cell.textTitle.text = "Duration:"
            cell.textValue.text = serviceDurationText
        case 3:
            cell.textTitle.text = "Change service description"
        case 4:
            cell.textTitle.text = "Change location service"
        case 5:
            cell.textTitle.text = "Add images"
        case 6:
            cell.textTitle.text = "Share this service"
            cell.textTitle.textColor = .systemBlue
            cell.rightIcon.isHidden = true
        case 7:
            cell.textTitle.text = "Delete Service"
            cell.textTitle.textColor = .red
            cell.rightIcon.isHidden = true
        default:
            cell.textTitle.textColor = .black
            cell.rightIcon.isHidden = false
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 1:
            let viewController = ServicePayController()
            //viewController.costLabelInt = Int(servicePay) ?? 0
            //viewController.fromChangeService = true
            //viewController.delegate = self
            let navigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController, animated: true)
        case 2:
            let viewController = ServiceSchedulingController()
            //viewController.fromChangeService = true
            //viewController.delegate = self
            //viewController.timeShowLabel.text = serviceDurationText
            //let date = Calendar.current.date(bySettingHour:hour, minute: minutes, second: 0, of: Date())!
            //viewController.durationPicker.setDate(date, animated: true)
            let navigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController, animated: true)
        case 3:
            let viewController = ServiceExtraInformationController()
            viewController.delegate = self
            viewController.fromChangeService = true
            //viewController.serviceDescription = self.serviceDescription
            let navigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController, animated: true)
        case 4:
            let viewController = ServiceLocation()
            viewController.fromChangeService = true
            viewController.delegate = self
            viewController.latitude = latitude
            viewController.longitude = longitude
            //viewController.circleRadius.radius = circleDistance
            let navigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController, animated: true)
        case 5:
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumLineSpacing = 1
            flowLayout.minimumInteritemSpacing = 1
            let viewController = AddImagesController(collectionViewLayout: UICollectionViewFlowLayout())
            viewController.serviceID = jobID
            self.navigationController?.pushViewController(viewController, animated: true)
        case 6:
            createDynamicLink()
        case 7:
            showDeleteAlert()
        default:
            break
        }
        
    }
    
    
    func changeServicePay(value: String) {
        let db = Firestore.firestore()
        db.collection("Services").document(jobID).updateData([
            "servicePay": Double(value) ?? 0
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.servicePay = value
                self.updateTableView()
            }
        }
    }
    
    func changeServiceDuration(value: Int) {

        let db = Firestore.firestore()
        db.collection("Services").document(jobID).updateData([
            "serviceDuration": value
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.serviceDuration = value
                let time = self.minutesToHoursMinutes(minutes: value)
                self.hour = time.hours
                self.minutes = time.leftMinutes
                
                if(self.hour == 0){
                    self.serviceDurationText = String(self.minutes) + " min"
                } else {
                    if(self.hour == 1){
                        self.serviceDurationText = String(self.hour) + " hour " + String(self.minutes) + " min"
                    } else {
                        self.serviceDurationText = String(self.hour) + " hours " + String(self.minutes) + " min"
                    }
                }
                
                self.updateTableView()
            }
        }
    }
    
    
    func changeServiceLocation(latitude: Double, longitude: Double, circleDistance: CLLocationDistance) {
        let db = Firestore.firestore()
        db.collection("Services").document(jobID).updateData([
            "latitude": latitude,
            "longitude": longitude,
            "circleDistance": circleDistance
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.latitude = latitude
                self.longitude = longitude
                self.circleDistance = circleDistance
            }
        }
        
        
    }
    
    func changeServiceDescription(value: String) {
         let db = Firestore.firestore()
         db.collection("Services").document(jobID).updateData([
             "serviceDescription": value
         ]){ err in
             if let err = err {
                 print("Error adding document: \(err)")
             } else {
                 self.serviceDescription = value
             }
         }
     }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.leftBarButtonItem:
            self.dismiss(animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    func getData(){
        self.showSpinner(onView: view)
        let db = Firestore.firestore()
        db.collection("Services").document(jobID).getDocument { (document, error) in
            if let document = document, document.exists {
                //SERVICE DURATION
                self.serviceDuration = document.get("serviceDuration") as! Int
            
                let time = self.minutesToHoursMinutes(minutes: self.serviceDuration)
                self.hour = time.hours
                self.minutes = time.leftMinutes
                
                //set text
                if(self.hour == 0){
                    self.serviceDurationText = String(self.minutes) + " min"
                } else {
                    if(self.hour == 1){
                        self.serviceDurationText = String(self.hour) + " hour " + String(self.minutes) + " min"
                    } else {
                        self.serviceDurationText = String(self.hour) + " hours " + String(self.minutes) + " min"
                    }
                }
                //InputDetails.details.serviceDuration = (self.hour * 60) + self.minutes
                
                //SERVICE LOCATION
                self.latitude = document.get("latitude") as! Double
                self.longitude = document.get("longitude") as! Double
                self.circleDistance = document.get("circleDistance") as! Double
                
                self.serviceDescription = document.get("serviceDescription") as? String ?? "0"
                
                self.updateTableView()
                self.removeSpinner()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    func updateTableView () {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    func showDeleteAlert(){
        let refreshAlert = UIAlertController(title: "Delete?", message: "You will have to recreate this service.", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let db = Firestore.firestore()
            db.collection("Services").document(self.jobID).delete()
            refreshAlert.dismiss(animated: true, completion: {self.dismiss(animated: true, completion: nil)})
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            refreshAlert.dismiss(animated: true, completion: nil)
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    func createDynamicLink() {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "https://worktide.page.link"
        components.path = "/servicerID"
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let servicerID = URLQueryItem(name: "servicerID", value: userID)
        components.queryItems = [servicerID]
        
        guard let linkParameter = components.url else {return}
        
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://worktide.page.link") else {
            print("couldn't create FDL component")
            return
        }
        
        if let bundleID = Bundle.main.bundleIdentifier{
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)
        }
        shareLink.iOSParameters?.appStoreID = "1480167340"
        
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Book with me through worktide"
        
        shareLink.shorten{(url, warning, error) in
            if error != nil{
                print("Error")
                return
            }
            guard let url = url else {return}
            print(url.absoluteString)
            
            self.showShareSheet(url)
            
        }
    }
    
    func showShareSheet(_ url:URL){
        let promoText = "Book with me through Worktide."
        let activityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    
}


public class ChangeServiceInfoCell: UITableViewCell {
    
    public let textTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)!
        label.textColor = .black
        return label
    }()
    
    public let textValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
        return label
    }()
    
    public let rightIcon:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "backIconBlack"))
        imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        
        self.addSubview(textTitle)
        textTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        textTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(textValue)
        textValue.leadingAnchor.constraint(equalTo: textTitle.trailingAnchor, constant: 15).isActive = true
        textValue.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        textValue.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(rightIcon)
        rightIcon.heightAnchor.constraint(equalToConstant: 15).isActive = true
        rightIcon.widthAnchor.constraint(equalToConstant: 15).isActive = true
        rightIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rightIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
