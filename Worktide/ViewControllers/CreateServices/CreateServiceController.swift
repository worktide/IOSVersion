//
//  CreateServiceController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-10-31.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import MapKit

protocol ChangeServiceDelegate {
    func changeServiceLocation(latitude: Double, longitude:Double, circleDistance:CLLocationDistance)
    func changeServicePay(value: String)
    func changeServiceDuration(value: Int)
    func changeServiceDescription(value: String)
}

struct InputDetails {
    static var details: InputDetails = InputDetails()

    var serviceCategory:String?
    var serviceName:String?
    var latitude:Double?
    var longitude:Double?
    var circleDistance:CLLocationDistance?
    var servicePay:Double?
    var serviceDuration:Int?
    var serviceDescription:String?
    
    
}

class CreateServiceController:UITableViewController{

    let cellID = "buttonsCell"
    var categoryModel = [JobCategoryModel]()
    
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
        
    }

    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        title = "Service Category"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backIconBlack")!.withRenderingMode(.alwaysOriginal),style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
    }
    
    func setupTableView(){
        
        self.tableView.register(buttonsCell.self, forCellReuseIdentifier: "buttonsCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let insets = UIEdgeInsets(top: 25, left: 0, bottom: 50, right: 0)
        self.tableView.contentInset = insets
        self.tableView.tableFooterView = UIView()
        
        let allData = [
            JobCategoryModel(jobTitle: "Home", jobDescription: "For home cleaning, or snow shoveling", iconImagePath: "homeIcon")
            ,JobCategoryModel(jobTitle: "Car", jobDescription: "Anything from tire changes to car detailing", iconImagePath: "carIcon")
            ,JobCategoryModel(jobTitle: "Parlor", jobDescription: "Haircuts and eyelash extensions", iconImagePath: "barberIcon")
            ,JobCategoryModel(jobTitle: "Other", jobDescription: "Whatever else you can offer", iconImagePath: "none")]
        
        categoryModel.append(contentsOf: allData)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! buttonsCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let category = categoryModel[indexPath.row]
        
        cell.iconView.image = UIImage(named: category.iconImagePath!)
        cell.textTitle.text = category.jobTitle
        cell.textDescription.text = category.jobDescription
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = NameServiceController()
        InputDetails.details.serviceCategory = categoryModel[indexPath.row].jobTitle!
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.leftBarButtonItem:
            self.dismiss(animated: true, completion: nil)
            
        default:
            break
        }
    }
    

    
}


public class buttonsCell: UITableViewCell {
    
    public let textTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)!
        label.textColor = .black
        return label
    }()
    
    public let textDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .darkGray
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12)!
        return label
    }()
    
    public let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        
        self.addSubview(iconView)
        iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(textTitle)
        textTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        textTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        textTitle.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -15).isActive = true
        
        self.addSubview(textDescription)
        textDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        textDescription.topAnchor.constraint(equalTo: textTitle.bottomAnchor, constant: 5).isActive = true
        textDescription.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -15).isActive = true
        textDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
