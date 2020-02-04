//
//  DaysAvailabilityController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-09.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DaysAvailabilityController:UITableViewController{
    
    var daysOfWeekArray = DateFormatter().weekdaySymbols!
    
    var rightBarButtonItem : UIBarButtonItem!
    
    var availabilityModelArray = [AvailabilityModel]()
    
    var isBreakPremanent = false
    var breakDays = [Date]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setupNavigation()
        setupTableView()
    }
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        title = "Available Days"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backIconBlack")!.withRenderingMode(.alwaysOriginal),style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
        
        rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(menuButtonTapped))
    }
    
    func setupTableView(){
        
        tableView.register(DayOfWeekCell.self, forCellReuseIdentifier: "cellID")
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        daysOfWeekArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! DayOfWeekCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let daysRow = daysOfWeekArray[indexPath.row]
        cell.textTitle.text = daysRow
        
        if availabilityModelArray.contains(where: { $0.dayOfWeek == cell.textTitle.text!}) {
            cell.iconView.isHidden = false
        }
        
        
        //check if anything is selected
        if(availabilityModelArray.count == 0){
            // nothing selected
            self.navigationItem.rightBarButtonItem = nil
        } else {
            //something is selected
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        
        switch indexPath.row {
        case 7:
            switch isBreakPremanent {
            case true:
                cell.textTitle.textColor = .systemGreen
            default:
                cell.textTitle.textColor = .systemRed
            }
        default:
            cell.textTitle.textColor = .black
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 7){
            
            if(isBreakPremanent){
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Enable Calendar", style: .default, handler: { (_) in
                    self.showSpinner(onView: self.view)
                    
                    guard let userID = Auth.auth().currentUser?.uid else { return }
                    let db = Firestore.firestore()
                    db.collection("Users").document(userID).collection("Breaks").document("Breaks").setData([
                        "breakPermanent": false
                    ], merge: true){ err in
                        if err != nil {
                            self.removeSpinner()
                            self.showAlert()
                        } else {
                            self.removeSpinner()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in

                }))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Temporary break", style: .default, handler: { (_) in
                    let viewController = BreakCalendarController()
                    viewController.selectedDate = self.breakDays
                    let navigationController = UINavigationController(rootViewController: viewController)
                    navigationController.modalPresentationStyle = .overFullScreen
                    self.present(navigationController, animated: true)
                }))
                
                alert.addAction(UIAlertAction(title: "Disable calendar", style: .default, handler: { (_) in
                    let alert = UIAlertController(title: "Are you sure?", message: "This will end all your appointments and disallow people to book for your services.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Disable", style: .default, handler: { (_) in
                        alert.dismiss(animated: true, completion: {
                            let alert = UIAlertController(title: nil, message: "Disabling calendar...", preferredStyle: .alert)

                            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                            loadingIndicator.hidesWhenStopped = true
                            loadingIndicator.style = UIActivityIndicatorView.Style.gray
                            loadingIndicator.startAnimating();

                            alert.view.addSubview(loadingIndicator)
                            self.present(alert, animated: true, completion: nil)
                            
                            guard let userID = Auth.auth().currentUser?.uid else { return }
                            let db = Firestore.firestore()
                            db.collection("Users").document(userID).collection("Breaks").document("Breaks").setData([
                                "breakPermanent":true
                            ], merge: true){ err in
                                if err != nil {
                                    alert.dismiss(animated: true, completion: {
                                        self.showAlert()
                                    })
                                } else {
                                    alert.dismiss(animated: true, completion: {self.dismiss(animated: true, completion: nil)})
                                }
                            }
                            
                        })
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in

                    }))
                    self.present(alert, animated: true, completion: nil)
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in

                }))
                
                self.present(alert, animated: true, completion: nil)
            }

        }
        
        let cell = tableView.cellForRow(at: indexPath) as! DayOfWeekCell
        
        if(indexPath.row != 7){
            if(cell.iconView.isHidden){
            cell.iconView.isHidden = false
            availabilityModelArray.append(AvailabilityModel(dayOfWeek: cell.textTitle.text!, startTime: "9:00 AM", endTime: "5:00 PM"))
        } else {
            cell.iconView.isHidden = true
            if let index = availabilityModelArray.firstIndex(where: { $0.dayOfWeek == cell.textTitle.text! }) {
                availabilityModelArray.remove(at: index)
            }
        }
        }
        
        //check if anything is selected
        if(availabilityModelArray.count == 0){
            // nothing selected
            self.navigationItem.rightBarButtonItem = nil
        } else {
            //something is selected
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func getData(){
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("Users").document(userID).collection("MySchedule").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.availabilityModelArray.append(AvailabilityModel(dayOfWeek: document.documentID, startTime: document.get("startTime") as? String, endTime: document.get("endTime") as? String))
                        self.tableView.reloadData()
                    }
                }
        }
        
        let dbBreak = Firestore.firestore()
        dbBreak.collection("Users").document(userID).collection("Breaks").document("Breaks").getDocument { (document, error) in
            if let document = document, document.exists {
                self.isBreakPremanent = document.get("breakPermanent") as? Bool ?? false
                if(self.isBreakPremanent){
                    self.daysOfWeekArray.append("Enable Calendar")
                } else {
                    self.daysOfWeekArray.append("Need a break?")
                }
                
                let timeStamp = document.get("breakArray") as! [Timestamp]
                for time in timeStamp{
                    self.breakDays.append(time.dateValue())
                }
                
                self.tableView.reloadData()
            } else {
                self.daysOfWeekArray.append("Need a break?")
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "please try again", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.leftBarButtonItem:
            self.dismiss(animated: true, completion: nil)
        case self.navigationItem.rightBarButtonItem:
            
            availabilityModelArray.sort(by: {
                (daysOfWeekArray.firstIndex(of: $0.dayOfWeek!) ?? Int.max) < (daysOfWeekArray.firstIndex(of: $1.dayOfWeek!) ?? Int.max)})
            
            let viewController = TimeAvailabilityController()
            viewController.availabilityModelArray = availabilityModelArray
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
    
}

class DayOfWeekCell:UITableViewCell{
    
    public let textTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)!
        label.textColor = .black
        return label
    }()
    
    public let iconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "selectedIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        
        self.addSubview(iconView)
        iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(textTitle)
        textTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        textTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textTitle.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -15).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

