//
//  GetUserLocationController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-20.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import GooglePlaces
import FirebaseAuth
import FirebaseFirestore

class GetUserLocationController:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var shouldShowAppointmentsController = false
    
    let googleAutoCompeteApi = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=address&location=%@,%@&radius=5000&language=en&key=%@&components=country:ca"
    var arrPlaces = NSMutableArray(capacity: 100)
    let operationQueue = OperationQueue()
    let googleServerkey = "AIzaSyDaJzlSVSsjbL0u3SvAZ5azlCQVrEifklo"
    
    var fromMainViewController = false
    var fromServiceLocation = false
    var delegate: MainViewControllerDelegate?
    var sendStringDelegate: SendStringDataDelegate?
    
    
    public let backButton: UIImageView = {
        let tintedImage = UIImage(named: "backIconBlack")!.withRenderingMode(.alwaysTemplate)
        let button = UIImageView(image: tintedImage)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    private let imageView: UIImageView = {
        let tintedImage = UIImage(named: "navigationMarker")!.withRenderingMode(.alwaysTemplate)
        let button = UIImageView(image: tintedImage)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    public let text: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.center
        textView.adjustsFontSizeToFitWidth = true
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
        textView.numberOfLines = 0
        textView.text = "What's your address?"
        return textView
    }()
    
    let searchBar:UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type your address"
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 10
        textField.textAlignment = NSTextAlignment.center
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        return textField
    }()
    
    let tableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        setupView()
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func setupView(){
        
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.addTapGestureRecognizer{
            self.dismiss(animated: true, completion: nil)
        }
        
        view.addSubview(imageView)
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 80).isActive = true
        
        view.addSubview(text)
        text.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        text.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        text.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        
        view.addSubview(searchBar)
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        searchBar.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 25).isActive = true
        
        view.addSubview(tableView)
        tableView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 15).isActive = true
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddressSuggestionCell.self, forCellReuseIdentifier: "addressCell")
        self.tableView.separatorStyle = .none
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath as IndexPath) as! AddressSuggestionCell
        cell.selectionStyle = .none
        
        let fullAddressArray = (arrPlaces[indexPath.row] as! String).split(separator: ",", maxSplits: 1).map(String.init)
        
        cell.title.text = fullAddressArray[0]
        cell.subTitle.text = fullAddressArray[1]
        
        switch indexPath.row {
        case arrPlaces.count - 1:
            cell.layer.cornerRadius = 10
            cell.lineBelow.isHidden = false
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case 0:
            cell.layer.cornerRadius = 10
            cell.lineBelow.isHidden = true
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        default:
            cell.layer.masksToBounds = false
            cell.layer.cornerRadius = 0
            cell.lineBelow.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAddress = arrPlaces[indexPath.row] as! String
        
        if(fromServiceLocation){
            sendStringDelegate?.sendStringData(stringArray: [selectedAddress])
            self.dismiss(animated: true, completion:nil)
        } else {
            UserDefaults.standard.set(selectedAddress, forKey: "usersAddress")
            
            if(fromMainViewController){
                delegate?.changeUsersAddress(usersAddress: selectedAddress)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.shouldAppointmentController()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.imageView.alpha = 1
            self.text.alpha = 1
            self.searchBar.topAnchor.constraint(equalTo: self.text.bottomAnchor, constant: 25).isActive = true
            self.view.layoutIfNeeded()
        })
        
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.imageView.alpha = 0
            self.text.alpha = 0
            self.searchBar.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 30).isActive = true
            self.view.layoutIfNeeded()
        })
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        self.beginSearching(searchText: searchBar.text ?? "")
        
    }

    func beginSearching(searchText:String) {
        if searchText.count == 0 {
            self.arrPlaces.removeAllObjects()
            self.tableView.reloadData()
            return
        }

        if(searchBar.text!.count > 2){
            operationQueue.addOperation { () -> Void in
                self.forwardGeoCoding(searchTexts:searchText)
            }
        }
    }
        

    func forwardGeoCoding(searchTexts:String) {
        googlePlacesResult(input: searchTexts) { (result) -> Void in
            let searchResult:NSDictionary = ["keyword":searchTexts,"results":result]
            if result.count > 0
            {
                let features = searchResult.value(forKey: "results") as! [AnyObject]
                self.arrPlaces = NSMutableArray(capacity: 100)

                for dictAddress in features   {
                    if let content = dictAddress.value(forKey:"description") as? String {
                        self.arrPlaces.addObjects(from: [content])
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func googlePlacesResult(input: String, completion: @escaping (_ result: NSArray) -> Void) {
        let searchWordProtection = input.replacingOccurrences(of: " ", with: "")
        if searchWordProtection.count != 0 {
            
            //note: latitude and longitude of winnipeg, change to users next time
            let latitude = "49.8951"
            let longitude = "-97.1384"
            
            let urlString = NSString(format: googleAutoCompeteApi as NSString,input,latitude,longitude,googleServerkey)
            let url = NSURL(string: urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)
            let defaultConfigObject = URLSessionConfiguration.default
            let delegateFreeSession = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: OperationQueue.main)
            let request = NSURLRequest(url: url! as URL)
            let task =  delegateFreeSession.dataTask(with: request as URLRequest,completionHandler: {
                (data, response, error) -> Void in
                if let data = data {
                    do {
                        let jSONresult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                        let results:NSArray = jSONresult["predictions"] as! NSArray
                        let status = jSONresult["status"] as! String

                        if status == "NOT_FOUND" || status == "REQUEST_DENIED" {
                            let userInfo:NSDictionary = ["error": jSONresult["status"]!]

                            let newError = NSError(domain: "API Error", code: 666, userInfo: userInfo as [NSObject : AnyObject] as [NSObject : AnyObject] as? [String : Any])
                            let arr:NSArray = [newError]
                            completion(arr)
                            return
                        } else {
                            completion(results)
                        }
                    }
                    catch {
                        print("json error: \(error)")
                    }
                } else if error != nil {
                    // print(error.description)
                }
            })
            task.resume()
        }
    }
    
    func setGradientBackground() {
        let colorBottom =  UIColor(red: 52/255.0, green: 52/255.0, blue: 52/255.0, alpha: 1.0).cgColor
        let colorTop = UIColor(red: 0/255.0, green: 132/255.0, blue: 227/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds

        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func shouldAppointmentController(){
        guard let userID = Auth.auth().currentUser?.uid else {
            self.showMainViewController()
            return
        }
        
        let db = Firestore.firestore()
        db.collection("Services").whereField("creatorID", isEqualTo: userID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot?.count == 0 {
                        self.shouldShowAppointmentsController = false
                    } else{
                        self.shouldShowAppointmentsController = true
                    }
                    
                    self.showMainViewController()
                    
                    
                }
        }
    }
    
    func showMainViewController(){
        let tabBarController = TabBarController()
        tabBarController.shouldShowAppointmentsController = shouldShowAppointmentsController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = tabBarController
        
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: appdelegate.window!, duration: duration, options: options, animations: {}, completion:
        { completed in
        })
    }
    
}

class AddressSuggestionCell:UITableViewCell{
    
    public let title: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        textView.numberOfLines = 1
        textView.adjustsFontSizeToFitWidth = true
        return textView
    }()
    
    public let subTitle: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .darkGray
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        textView.numberOfLines = 1
        textView.adjustsFontSizeToFitWidth = true
        return textView
    }()
    
    public let lineBelow:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        self.backgroundColor = .white
        
        self.addSubview(title)
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        
        self.addSubview(subTitle)
        subTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        subTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2).isActive = true
        
        self.addSubview(lineBelow)
        lineBelow.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineBelow.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lineBelow.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
