//
//  NameServiceController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-03.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseFirestore
import HCSStarRatingView

class NameServiceController: UITableViewController, UITextFieldDelegate{
    
    let cellID = "buttonsCell"
    var serviceModel = [RecommendedServiceModel]()
    
    var rightBarButtonItem : UIBarButtonItem!
    
    private let containerLayout: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    public let textField: UITextField = {
        let textView = UITextField()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocapitalizationType = .words
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        textView.textAlignment = .left
        textView.placeholder = "What are you offering?"
        textView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        return textView
    }()
    
    private let suggestionsTitle: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.text = "Suggested"
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        textView.numberOfLines = 1
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setupViews()
        setupTableView()
        setupNavigation()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableView.tableHeaderView?.layoutIfNeeded()
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
    }
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        title = "Service Name"
        rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(menuButtonTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(menuButtonTapped))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    
    func setupTableView(){
        
        self.tableView.register(SuggestionsCell.self, forCellReuseIdentifier: "buttonsCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        self.tableView.contentInset = insets
        self.tableView.tableFooterView = UIView()
        
    }
    
    func setupViews(){
        
        self.tableView.tableHeaderView = containerLayout
        self.tableView.tableHeaderView?.isUserInteractionEnabled = true
        containerLayout.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerLayout.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
   
        self.textField.delegate = self
        containerLayout.addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -50).isActive = true
        textField.topAnchor.constraint(equalTo: containerLayout.topAnchor, constant: 50).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        containerLayout.addSubview(suggestionsTitle)
        suggestionsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        suggestionsTitle.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 50).isActive = true
        suggestionsTitle.bottomAnchor.constraint(equalTo: containerLayout.bottomAnchor).isActive = true
    
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceModel.count
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SuggestionsCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.ratingStar.value = serviceModel[indexPath.row].serviceRating ?? 0
        cell.serviceName.text = serviceModel[indexPath.row].serviceTitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.text = serviceModel[indexPath.row].serviceTitle
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //Data Management------------------------------------------\
    
    func getData(){
        
        let db = Firestore.firestore()
        db.collection("Misc").document("RecommendedServices").getDocument { (document, error) in
            if let document = document, document.exists {
                let nameArray = document.get("serviceTitle") as! [String]
                
                for name in nameArray{
                    let titleArray = name.components(separatedBy: "-")
                    
                    self.serviceModel.append(RecommendedServiceModel(serviceTitle:titleArray[1], serviceRating: titleArray[0]))
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //-------------------------------------------
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textField {
            if (!textField.text!.isEmpty){
                nextPage()
            }
            
            return false
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (!textField.text!.isEmpty){
            self.navigationItem.rightBarButtonItem = self.rightBarButtonItem
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    
    func nextPage(){
        
        let createServiceModel = CreateServiceModel()
        createServiceModel.serviceTitle = textField.text
        
        let viewController = QuestionsController()
        viewController.createServiceModel = createServiceModel
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            nextPage()
        default:
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    

    
}

class SuggestionsCell:UITableViewCell{
    
    public let serviceName:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    
    public let ratingStar:HCSStarRatingView = {
        let ratingStar = HCSStarRatingView()
        ratingStar.translatesAutoresizingMaskIntoConstraints = false
        ratingStar.maximumValue = 5
        ratingStar.minimumValue = 0
        ratingStar.isUserInteractionEnabled = false
        ratingStar.filledStarImage = UIImage(imageLiteralResourceName: "fireIcon")
        ratingStar.emptyStarImage = UIImage(imageLiteralResourceName: "simpleCarIcon")
        return ratingStar
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    func setupView(){
        self.backgroundColor = .white
        
        self.addSubview(ratingStar)
        ratingStar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        ratingStar.heightAnchor.constraint(equalToConstant: 18).isActive = true
        ratingStar.widthAnchor.constraint(equalToConstant: 120).isActive = true
        ratingStar.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(serviceName)
        serviceName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        serviceName.trailingAnchor.constraint(equalTo: ratingStar.leadingAnchor, constant: -10).isActive = true
        serviceName.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

