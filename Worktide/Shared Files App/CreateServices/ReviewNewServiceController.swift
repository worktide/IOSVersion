//
//  ReviewNewServiceController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-03-02.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore
import FirebaseAuth

class ReviewNewServiceController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MKMapViewDelegate{
    
    var createServiceModel:CreateServiceModel!
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private let stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 40
        stackView.alignment = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    private let serviceTitleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Service Title"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    private let serviceTitleText:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    private let variedPricingLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Varied Pricing"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    private let variedPricingDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.textAlignment = .left
        label.text = "This service will let you customize your own price based on the answers from the customer."
        label.numberOfLines = 0
        return label
    }()
    
    private let variedPricingPrice:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let questionsTitleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Questions for customer:"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    let questionsCollectionView:UICollectionView = {
        let tableView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let locationLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Service Area"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    private let serviceLocationDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.textAlignment = .left
        label.text = "To save you the distance, people outside of this circle will not be able to see this service.\n\nChange this location type if it does not suit you."
        label.numberOfLines = 0
        return label
    }()
    
    private let mapView:MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isUserInteractionEnabled = false
        mapView.layer.cornerRadius = 12
        return mapView
    }()
    
    private let estimatedDurationLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Estimated Duration"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    private let estimatedDurationDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let linkedSpotsLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Linked Spots"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    private let linkedSpotsDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let scheduleCollectionView:UICollectionView = {
        let tableView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let serviceDescriptionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Service Description"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    private let serviceDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let noteForCustomerLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Note for customer"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    private let noteForCustomerDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let serviceImagesLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Showcasing images"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    let imagesCollectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let tableView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let confirmButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit for Review", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        title = "Review Service"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
        setupNavigation()
        setupCollectionView()
        setupMaps()
    }
    
    func setupView(){
    
        view.addSubview(scrollView)
        view.addSubview(confirmButton)
        
        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -150).isActive = true
        
        stackView.addArrangedSubview(serviceTitleLabel)
        stackView.setCustomSpacing(10, after: serviceTitleLabel)
        stackView.addArrangedSubview(serviceTitleText)
        
        stackView.addArrangedSubview(variedPricingLabel)
        stackView.setCustomSpacing(10, after: variedPricingLabel)
        stackView.addArrangedSubview(variedPricingDescription)
        stackView.setCustomSpacing(10, after: variedPricingDescription)
        stackView.addArrangedSubview(variedPricingPrice)
        
        stackView.addArrangedSubview(questionsTitleLabel)
        stackView.setCustomSpacing(10, after: questionsTitleLabel)
        stackView.addArrangedSubview(questionsCollectionView)
        
        stackView.addArrangedSubview(locationLabel)
        stackView.setCustomSpacing(10, after: locationLabel)
        stackView.addArrangedSubview(serviceLocationDescription)
        stackView.setCustomSpacing(10, after: serviceLocationDescription)
        stackView.addArrangedSubview(mapView)
        
        stackView.addArrangedSubview(estimatedDurationLabel)
        stackView.setCustomSpacing(10, after: estimatedDurationLabel)
        stackView.addArrangedSubview(estimatedDurationDescription)
        
        stackView.addArrangedSubview(linkedSpotsLabel)
        stackView.setCustomSpacing(10, after: linkedSpotsLabel)
        stackView.addArrangedSubview(linkedSpotsDescription)
        stackView.setCustomSpacing(10, after: linkedSpotsDescription)
        stackView.addArrangedSubview(scheduleCollectionView)
        
        stackView.addArrangedSubview(serviceDescriptionLabel)
        stackView.setCustomSpacing(10, after: serviceDescriptionLabel)
        stackView.addArrangedSubview(serviceDescription)
        
        stackView.addArrangedSubview(noteForCustomerLabel)
        stackView.setCustomSpacing(10, after: noteForCustomerLabel)
        stackView.addArrangedSubview(noteForCustomerDescription)
        
        stackView.addArrangedSubview(serviceImagesLabel)
        stackView.addArrangedSubview(imagesCollectionView)
        
        serviceTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        serviceTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        serviceTitleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        
        serviceTitleText.text = createServiceModel.serviceTitle
        serviceTitleText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        serviceTitleText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        variedPricingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        variedPricingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        variedPricingDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        variedPricingDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        variedPricingPrice.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        variedPricingPrice.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        questionsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        questionsTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        questionsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        questionsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        questionsCollectionView.heightAnchor.constraint(equalToConstant: (CGFloat(30 * (createServiceModel.questionArray?.count ?? 0)))).isActive = true
        
        locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        serviceLocationDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        serviceLocationDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        linkedSpotsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        linkedSpotsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        linkedSpotsDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        linkedSpotsDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        scheduleCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        scheduleCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        scheduleCollectionView.heightAnchor.constraint(equalToConstant: (CGFloat(30 * (createServiceModel.scheduleArray?.count ?? 0)))).isActive = true
        
        serviceDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        serviceDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        serviceDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        serviceDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        noteForCustomerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        noteForCustomerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        noteForCustomerDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        noteForCustomerDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        serviceImagesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        serviceImagesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        let cellHeight = view.frame.width/3
        let numberOfRows = Double(createServiceModel.serviceImages?.count ?? 0) / 3
        imagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imagesCollectionView.heightAnchor.constraint(equalToConstant: cellHeight * CGFloat(numberOfRows.rounded(.up))).isActive = true
        print(numberOfRows)
        print(cellHeight)
        
        //scrollView.bounces = false
        questionsCollectionView.bounces = true
        scheduleCollectionView.bounces = true
        imagesCollectionView.bounces = true
        
    }
    
    func setupData(){
        
        //Map View
        if createServiceModel.circleRadius == 0{
            serviceLocationDescription.text = "Your address will be displayed and people will come to you for your servies.\n\nChange this location type if it does not suit you."
            locationLabel.text  = "Service Location"
        }
        
        var text = "Customers will be able to book a spot every \(createServiceModel.estimatedDuration!.minutesToWords())."
        
        //Linked Spots
        if createServiceModel.scheduleArray?.count == 0{
            text = "Your estimated duration for the service is \(createServiceModel.estimatedDuration!.minutesToWords())."
            linkedSpotsDescription.text = "You are not connected to any schedule. Please include a note for the customer about your scheduling terms."
        } else {
            linkedSpotsDescription.text = "You can have \(createServiceModel.scheduleArray!.count) total customers at the same time."
        }
        
        //Varied Pricing or Base Pricing
        if !createServiceModel.variedPricing! {
            variedPricingLabel.text = "Base Pricing"
            variedPricingDescription.text = "Charge this base price for your service."
            variedPricingPrice.text = "$\(createServiceModel.basePrice!) CAD"
            
            //no questions if not varied
            questionsTitleLabel.isHidden = true
            questionsCollectionView.isHidden = true
        } else {
            variedPricingPrice.text = "$\(createServiceModel.minimumPrice!) ~ $\(createServiceModel.maximumPrice!) CAD"
            
            text = "Customers can only book with you after you have given them an estimated duration.\n\n\(createServiceModel.estimatedDuration!.minutesToWords())"
        }
        
        //Estimated Duration
        estimatedDurationDescription.text = text
        
        let regularFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        let boldFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        estimatedDurationDescription.attributedText = HelperForReading.addBoldText(fullString: text as NSString, boldPartsOfString: [createServiceModel.estimatedDuration!.minutesToWords()], font: regularFont, boldFont: boldFont)
        
        
        //Service Description
        serviceDescription.text = createServiceModel.serviceDescription
        
        //Note for Customer
        if createServiceModel.noteToCustomer!.isEmpty{
            noteForCustomerDescription.isHidden = true
            noteForCustomerLabel.isHidden = true
        } else {
            noteForCustomerDescription.text = createServiceModel.noteToCustomer
        }
        
        //Images
        if createServiceModel.serviceImages?.count == 0{
            serviceImagesLabel.isHidden = true
            imagesCollectionView.isHidden = true
        }
        
    }

    //Map Kit-------------------------------------------------------------------
    
    func setupMaps(){
        mapView.delegate = self
        
        var mapViewZoom = (createServiceModel.circleRadius! * 2) + 200
        
        if createServiceModel.circleRadius == 0 {
            
            let annotation = MKPointAnnotation()
            annotation.title = createServiceModel.address
            annotation.coordinate = createServiceModel.location!
            mapView.addAnnotation(annotation)
            
            mapViewZoom = 1500
        }
        
        let region = MKCoordinateRegion(center: createServiceModel.location!, latitudinalMeters: mapViewZoom, longitudinalMeters: mapViewZoom)
        mapView.setRegion(region, animated: false)
        
        let circle = MKCircle(center: createServiceModel.location!, radius: createServiceModel.circleRadius ?? 0)
        self.mapView.addOverlay(circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        }
        
        return MKPolylineRenderer()
    }
    
    //TableView-----------------------------
    func setupCollectionView(){
        
        self.questionsCollectionView.register(TextCell.self, forCellWithReuseIdentifier: "TextCell")
        self.questionsCollectionView.delegate = self
        self.questionsCollectionView.dataSource = self
        
        self.scheduleCollectionView.register(TextCell.self, forCellWithReuseIdentifier: "TextCell")
        self.scheduleCollectionView.delegate = self
        self.scheduleCollectionView.dataSource = self
        
        self.imagesCollectionView.register(ImagesCell.self, forCellWithReuseIdentifier: "ImagesCell")
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case questionsCollectionView:
            return createServiceModel.questionArray?.count ?? 0
        case scheduleCollectionView:
            return createServiceModel.scheduleArray?.count ?? 0
        default:
            //images cell
            return createServiceModel.serviceImages?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case questionsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath as IndexPath) as! TextCell
            cell.titleLabel.text = "\"" + createServiceModel.questionArray![indexPath.row] + "\""
            return cell
        case scheduleCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath as IndexPath) as! TextCell
            cell.titleLabel.text = createServiceModel.scheduleArray![indexPath.row]
            return cell
        default:
            //images cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath as IndexPath) as! ImagesCell
            cell.imageView.image = createServiceModel.serviceImages![indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case imagesCollectionView:
            let cellHeight = view.frame.width/3
            return CGSize(width: cellHeight, height: cellHeight)
        default:
            return CGSize(width: view.frame.width, height: 20)
        }
    }
    
    //listeners-------------------------------------------------------------------------------
    
    @objc func doneButton(sender: UIButton!) {
        let userID = Auth.auth().currentUser?.uid
        
        /*let db = Firestore.firestore()
        db.collection("Services").document().setData([
            "creatorID": userID!,
            "latitude": createServiceModel.location!.latitude,
            "longitude":createServiceModel.location!.longitude,
            "circleDistance": createServiceModel.circleRadius ?? 0,
            "timeCreated":Date(),
            "serviceStatus": 0,
            "serviceName": createServiceModel.serviceTitle!,
            "servicePay": createServiceModel.basePrice ?? nil!,
            "serviceMinimumPay": createServiceModel.minimumPrice ?? nil!,
            "serviceMaximumPay": createServiceModel.maximumPrice ?? nil!,
            "serviceDescription": createServiceModel.serviceDescription ?? nil!,
            
        ])*/
        let viewController = CompletedController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            questionsCollectionView.isScrollEnabled = (self.scrollView.contentOffset.y >= 200)
            scheduleCollectionView.isScrollEnabled = (self.scrollView.contentOffset.y >= 200)
            imagesCollectionView.isScrollEnabled = (self.scrollView.contentOffset.y >= 200)
        }

        if scrollView == self.questionsCollectionView {
            self.questionsCollectionView.isScrollEnabled = (questionsCollectionView.contentOffset.y > 0)
        }
        
        if scrollView == self.scheduleCollectionView {
            self.scheduleCollectionView.isScrollEnabled = (scheduleCollectionView.contentOffset.y > 0)
        }
        
        if scrollView == self.imagesCollectionView {
            self.imagesCollectionView.isScrollEnabled = (imagesCollectionView.contentOffset.y > 0)
        }
    }
    
}

class TextCell: UICollectionViewCell {
    
    public let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
