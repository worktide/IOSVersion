//
//  AvailabilityController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-20.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AvailabilityController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    var availabilityModelArray = [AvailabilityModel(dayOfWeek: "Monday", startTime: "9:00 AM", endTime: "5:00 PM"),AvailabilityModel(dayOfWeek: "Tuesday", startTime: "9:00 AM", endTime: "5:00 PM"),AvailabilityModel(dayOfWeek: "Wednesday", startTime: "9:00 AM", endTime: "5:00 PM"),AvailabilityModel(dayOfWeek: "Thursday", startTime: "9:00 AM", endTime: "5:00 PM"),AvailabilityModel(dayOfWeek: "Friday", startTime: "9:00 AM", endTime: "5:00 PM"),AvailabilityModel(dayOfWeek: "Saturday", startTime: "9:00 AM", endTime: "5:00 PM"),AvailabilityModel(dayOfWeek: "Sunday", startTime: "9:00 AM", endTime: "5:00 PM")]
    
    let daysCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let dayFlowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    var dimView = UIView()
    var timeChosen = "09:00 AM"
    var isFromStart = true //which button was pressed for datepicker
    var currentRow = 0
    
    var workingArray = [AvailabilityModel]()
    
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
    
    private let disableButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Working", for: .normal)
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
    
    private let setAllTimeButton:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Set this time for all days"
        label.textColor = .systemBlue
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        return label
    }()
    
    private let doneImage:UIImageView = {
        let imageView = UIImageView(image:UIImage(named: "selectedIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupView()
        setupNavigation()
        getData()
        
        let currentRow = availabilityModelArray[0]
        fromTimeChosen.setTitle(currentRow.startTime, for: .normal)
        toTimeChosen.setTitle(currentRow.endTime, for: .normal)
    }
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        title = "Availability Scheduler"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(menuButtonTapped))
    }

    
    func setupView(){
        view.backgroundColor = .white
        
        view.addSubview(daysCollectionView)
        daysCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        daysCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        daysCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        daysCollectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(fromTitle)
        fromTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        fromTitle.topAnchor.constraint(equalTo: daysCollectionView.bottomAnchor, constant: 25).isActive = true
        
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
        
        view.addSubview(setAllTimeButton)
        setAllTimeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        setAllTimeButton.topAnchor.constraint(equalTo: toTimeChosen.bottomAnchor, constant: 25).isActive = true
        setAllTimeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        setAllTimeButton.addTapGestureRecognizer{
            for i in 0..<self.availabilityModelArray.count {
                self.availabilityModelArray[i].startTime = self.fromTimeChosen.titleLabel!.text
                self.availabilityModelArray[i].endTime = self.toTimeChosen.titleLabel!.text
            }
            UIView.animate(withDuration: 0.3) {
                self.doneImage.alpha = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: 0.3) {
                    self.doneImage.alpha = 0
                }
            }
            
        }
        
        view.addSubview(doneImage)
        doneImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        doneImage.topAnchor.constraint(equalTo: setAllTimeButton.bottomAnchor, constant: 15).isActive = true
        doneImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        doneImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(disableButton)
        disableButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        disableButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        disableButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        disableButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupCollectionView(){
        
        let cellSize = CGSize(width:view.frame.width, height:150)
        dayFlowLayout.itemSize = cellSize
        dayFlowLayout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        dayFlowLayout.scrollDirection = .horizontal
        dayFlowLayout.minimumInteritemSpacing = 0
        dayFlowLayout.minimumLineSpacing = 0
        
        daysCollectionView.backgroundColor = .blue
        daysCollectionView.setCollectionViewLayout(dayFlowLayout, animated: true)
        daysCollectionView.register(TimeAvailableCell.self, forCellWithReuseIdentifier: "collectionCellA")
        daysCollectionView.delegate = self
        daysCollectionView.dataSource = self
        daysCollectionView.backgroundColor = .white
        daysCollectionView.showsHorizontalScrollIndicator = false
        daysCollectionView.isPagingEnabled = true
        daysCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        availabilityModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCellA", for: indexPath) as! TimeAvailableCell
        
        let daysRow = availabilityModelArray[indexPath.row]
        
        cell.indexNumber.text = String(indexPath.row + 1)
        cell.dayText.text = daysRow.dayOfWeek
        
        switch indexPath.row {
        case 0:
            cell.leftIcon.isHidden = true
            cell.rightIcon.isHidden = false
            if (indexPath.row == availabilityModelArray.count - 1){
                //last item
                cell.rightIcon.isHidden = true
            }
        case self.collectionView(collectionView, numberOfItemsInSection: 0) - 1:
            cell.rightIcon.isHidden = true
            cell.leftIcon.isHidden = false
        default:
            cell.rightIcon.isHidden = false
            cell.leftIcon.isHidden = false
        }
        
        return cell
    }
    
    @objc func buttonAction(sender: UIButton) {
        switch sender {
        case self.fromTimeChosen:
            openTimePicker(isFromStart: true)
        case self.toTimeChosen:
            openTimePicker(isFromStart: false)
        default:
            if(self.workingArray.contains(where:{$0.dayOfWeek?.dayOfWeekToInt() == currentRow})){
                self.workingArray = self.workingArray.filter{ $0.dayOfWeek?.dayOfWeekToInt() != currentRow}
            } else {
                let model = availabilityModelArray[currentRow]
                self.workingArray.append(AvailabilityModel(dayOfWeek: model.dayOfWeek, startTime: model.startTime, endTime: model.endTime))
            }
            self.updateView()
        }
    }
    
    //Do Functions--------------------------------------------------------------------
    
    func openTimePicker(isFromStart:Bool){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "hh:mm a"
        
        datePicker = UIDatePicker.init()
        datePicker.backgroundColor = UIColor.white
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .time
        
        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
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
        
        let currentRow = self.availabilityModelArray[self.currentRow]
        
        if(!isFromStart){
            datePicker.date = dateFormatter.date(from: currentRow.endTime!)!
            self.timeChosen = currentRow.endTime!
            self.isFromStart = false
        } else {
            datePicker.date = dateFormatter.date(from: currentRow.startTime!)!
            self.timeChosen = currentRow.startTime!
            self.isFromStart = true
        }
        
    }
    
    func getData(){
        
        let userID = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        db.collection("Users").document(userID).collection("MySchedule").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let dayOfWeek = document.documentID
                        let startTime = document.get("startTime") as? String
                        let endTime = document.get("endTime") as? String
                        
                        self.workingArray.append(AvailabilityModel(dayOfWeek: dayOfWeek, startTime: startTime, endTime: endTime))
                        
                        self.updateView()
                    }
                    
                    
                }
        }
        
    }
    
    func updateView(){
        if(self.workingArray.contains(where: {$0.dayOfWeek!.dayOfWeekToInt() == currentRow})){
            self.disableButton.backgroundColor = .systemBlue
            self.disableButton.setTitle("Available", for: .normal)
        } else {
            self.disableButton.backgroundColor = .lightGray
            self.disableButton.setTitle("Not Available", for: .normal)
        }
        
        let daysOfWeekModel = availabilityModelArray[self.currentRow]
        let model = workingArray.first(where:{$0.dayOfWeek?.dayOfWeekToInt() == self.currentRow})
        
        if(workingArray.contains(where:{$0.dayOfWeek?.dayOfWeekToInt() == self.currentRow})){
            fromTimeChosen.setTitle(model?.startTime, for: .normal)
            toTimeChosen.setTitle(model?.endTime, for: .normal)
        } else {
            fromTimeChosen.setTitle(daysOfWeekModel.startTime, for: .normal)
            toTimeChosen.setTitle(daysOfWeekModel.endTime, for: .normal)
        }
        
        daysCollectionView.reloadData()
    }
    
    //button listeners-------------------------------------------------------------------
    
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
            
            //change data
            if(self.isFromStart){
                let currentRow = self.availabilityModelArray[self.currentRow]
                self.availabilityModelArray[self.currentRow] = AvailabilityModel(dayOfWeek: currentRow.dayOfWeek, startTime: self.timeChosen, endTime: currentRow.endTime)
                self.fromTimeChosen.setTitle(self.timeChosen, for: .normal)
            } else {
                let currentRow = self.availabilityModelArray[self.currentRow]
                self.availabilityModelArray[self.currentRow] = AvailabilityModel(dayOfWeek: currentRow.dayOfWeek, startTime: currentRow.startTime, endTime: self.timeChosen)
                self.toTimeChosen.setTitle(self.timeChosen, for: .normal)
            }
            
        })
        
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
          
        let date = sender?.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        timeChosen = formatter.string(from: date!)
          
              
          
      }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let db = Firestore.firestore()
            
            //showLoading
            let alert = UIAlertController(title: nil, message: "Uploading", preferredStyle: .alert)
                
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.gray
            loadingIndicator.startAnimating()
                
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            
            //Delete previous Data
            let fullDaysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

            for string in fullDaysOfWeek {
                db.collection("Users").document(userID).collection("MySchedule").document(string).delete()
            }
            
            //Upload new data
            var dataCount = 0
            
            for day in workingArray {
                db.collection("Users").document(userID).collection("MySchedule").document(day.dayOfWeek!).setData([
                    "startTime": day.startTime!,
                    "endTime": day.endTime!
                ]){ err in
                    if err != nil {
                        alert.message = "Something went wrong"
                        loadingIndicator.stopAnimating()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            alert.dismiss(animated: true, completion: {self.dismiss(animated: true, completion: nil)})
                        }
                    } else {
                        dataCount = dataCount + 1
                        if(dataCount == self.workingArray.count){
                            alert.message = "Complete"
                            loadingIndicator.stopAnimating()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                alert.dismiss(animated: true, completion: {self.dismiss(animated: true, completion: nil)})
                            }
                        }
                    }
                }
            }
            
            
        default:
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //scrollview listener-----------------------------------------------------------------
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
           UIView.animate(withDuration: 0.3, animations: {
               self.setAllTimeButton.alpha = 0
               self.fromTitle.alpha = 0
               self.fromTimeChosen.alpha = 0
               self.toTitle.alpha = 0
               self.toTimeChosen.alpha = 0
            self.disableButton.alpha = 0
           })
       }
       
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
       if let ip = daysCollectionView.indexPathForItem(at: center) {
        
        self.currentRow = ip.row
           
        self.updateView()
        UIView.animate(withDuration: 0.3) {
           self.setAllTimeButton.alpha = 1
           self.fromTitle.alpha = 1
           self.fromTimeChosen.alpha = 1
           self.toTitle.alpha = 1
           self.toTimeChosen.alpha = 1
            self.disableButton.alpha = 1
           }
       }
   }
    
    
}


class TimeAvailableCell:UICollectionViewCell{
    
    public let indexNumber:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 32)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    public let dayText:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    public let rightIcon:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backIconBlack"), for: .normal)
        button.transform = CGAffineTransform(scaleX: -1, y: 1)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return button
    }()
    
    public let leftIcon:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backIconBlack"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.addSubview(indexNumber)
        indexNumber.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indexNumber.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        
        self.addSubview(dayText)
        dayText.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dayText.topAnchor.constraint(equalTo: indexNumber.bottomAnchor, constant: 10).isActive = true
        dayText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        
        self.addSubview(rightIcon)
        rightIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        rightIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rightIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rightIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.addSubview(leftIcon)
        leftIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        leftIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leftIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        leftIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
