//
//  NameServiceController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-03.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class NameServiceController: UITableViewController, UITextFieldDelegate{
    
    let cellID = "buttonsCell"
    var serviceModel = [["Washroom Cleaning", "Kitchen Deep Clean", "Home Cleaning"], ["Shovel Driveway", "Lawn Trimming"], ["Assemble Furniture"]]
    
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
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textView.textAlignment = .left
        textView.placeholder = "create your own"
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
    }

    
    func setupTableView(){
        
        self.tableView.register(SuggestionsCell.self, forCellReuseIdentifier: "buttonsCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        self.tableView.contentInset = insets
        self.tableView.tableFooterView = UIView()
        
        let categoryChosen = InputDetails.details.serviceCategory
        
        switch categoryChosen {
        case "Home":
            break
        case "Car":
            serviceModel = [["Interior Car Detailing", "Exterior Car Detailing", "Overall Car Detailing", "Car Wash"], ["Tire Change", "Battery Change"]]
        case "Parlor":
            serviceModel = [["Men's Haircut", "Women's Haircut"], ["Eyelash Extension"], ["Eyebrow Threading"]]
        case "Other":
            serviceModel = []
            suggestionsTitle.isHidden = true
        default:
            break
        }
               
    
        
    }
    
    func setupViews(){
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.tableView.tableHeaderView = containerLayout
        self.tableView.tableHeaderView?.isUserInteractionEnabled = true
        containerLayout.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerLayout.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
   
        self.textField.delegate = self
        containerLayout.addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        textField.topAnchor.constraint(equalTo: containerLayout.topAnchor, constant: 50).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerLayout.addSubview(suggestionsTitle)
        suggestionsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        suggestionsTitle.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 50).isActive = true
        suggestionsTitle.bottomAnchor.constraint(equalTo: containerLayout.bottomAnchor).isActive = true
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceModel[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        serviceModel.count
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
        
        cell.serviceName.text = serviceModel[indexPath.section][indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ServiceLocation()
        InputDetails.details.serviceName = serviceModel[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
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
        let viewController = ServiceLocation()
        InputDetails.details.serviceName = textField.text
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            nextPage()
        default:
            break
        }
    }

    
    

    
}

class SuggestionsCell:UITableViewCell{
    
    public let serviceName:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    func setupView(){
        self.backgroundColor = .white
        
        self.addSubview(serviceName)
        serviceName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        serviceName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        serviceName.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

