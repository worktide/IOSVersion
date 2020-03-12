//
//  BookServicesController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-12-16.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import MapKit

class BookServicesController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var userID:String!
    var serviceDuration:Int!
    var location:CLLocationCoordinate2D!
    
    var daysAvailableArray = [BookingsModel]()
    var doesUserHaveCalendar = false
    var isUserOnBreak = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        setupCollectionView()
        //getData()
        getData1()
    }
    
    func setupCollectionView(){
        
        let inset = UIEdgeInsets(top: 25, left: 0, bottom: 80, right: 0)
        collectionView.contentInset = inset
        
        collectionView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        collectionView.delegate = self
        collectionView.register(DaysAvailableCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.allowsSelection = true
        
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(!doesUserHaveCalendar || isUserOnBreak){
            return 1
        } else {
            return daysAvailableArray.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(doesUserHaveCalendar && !isUserOnBreak){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DaysAvailableCell
            let model = daysAvailableArray[indexPath.row]
            cell.dayOfWeekTitle.text = model.bookDateDisplay
            cell.status.text = model.spotsAvailable
            cell.rightIcon.isHidden = false
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DaysAvailableCell
            cell.dayOfWeekTitle.text = "This user is not available"
            cell.status.text = "Check back again later."
            cell.rightIcon.isHidden = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(doesUserHaveCalendar && !isUserOnBreak){
            let model = daysAvailableArray[indexPath.row]
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumLineSpacing = 25
            flowLayout.minimumInteritemSpacing = 5
            
            let viewController = TimeSelectServiceController(collectionViewLayout: flowLayout)
            viewController.timeAvailableArray = model.timesAvailable
            viewController.timeTitle = model.bookDateDisplay!
            viewController.dateChosen = model.bookDate
            viewController.userID = userID
            viewController.serviceDuration = serviceDuration
            viewController.location = location
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func getData1(){
        
        //NEXT 30 DAYS ARRAY
        var next30DaysArray = [Date]()
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        for _ in 1 ... 30 {
            next30DaysArray.append(date)
            date = cal.date(byAdding: .day, value: +1, to: date)!
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let db = Firestore.firestore().collection("Users").document(userID)
        db.collection("MySchedule").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    var daysOfWeekAvailaiblityArray = [AvailableDaysModel]()
                    
                    //Find and filter available dates based on day of week availability
                    var availableDays = [String]()
                    for document in querySnapshot!.documents{
                        self.doesUserHaveCalendar = true
                        
                        let dayOfWeek = document.documentID
                        let startTime = document.get("startTime") as! String
                        let endTime = document.get("endTime") as! String
                        
                        daysOfWeekAvailaiblityArray.append(AvailableDaysModel(dayOfWeek: dayOfWeek, startTime: startTime, endTime: endTime))
                        availableDays.append(dayOfWeek)
                        
                    }
                    var availableDates = [Date]()
                    for day in next30DaysArray{
                        let dayInString = dateFormatter.string(from: day)
                        
                        if(availableDays.contains(dayInString)){
                            availableDates.append(day)
                        }
                    }
                    
                    let dispatchQ = DispatchGroup()
                    dispatchQ.enter()
                    
                    DispatchQueue.main.async {
                        //filter availableDates to remove days on breaks
                        db.collection("Breaks").document("Breaks").getDocument { (document, error) in
                            if let document = document, document.exists {
                                let timeStamp = document.get("breakArray") as! [Timestamp]
                                for time in timeStamp{
                                    let breakDay = time.dateValue()
                                    availableDates = availableDates.filter({!Calendar.current.isDate($0, inSameDayAs: breakDay)})
                                }
                                if (document.get("breakPermanent") as! Bool){
                                    self.isUserOnBreak = true
                                    self.updateCollectionView()
                                }

                                dispatchQ.leave()
                            } else {
                                print("Document does not exist")
                                dispatchQ.leave()
                            }
                        }
                        
                    }
                    
                    var x = 0
                    dispatchQ.notify(queue: .main) {
                        x += 1
                        if(x == 1){
                            let bookingsDB = Firestore.firestore()
                            bookingsDB.collection("Bookings").whereField("servicer", isEqualTo: self.userID!).getDocuments() { (querySnapshots, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        var timeRangeArray = [TimeRangeModel]()
                                        for document in querySnapshots!.documents {
                                            let timeStart = (document.get("startDate") as! Timestamp).dateValue()
                                            let timeEnd = (document.get("endDate") as! Timestamp).dateValue()
                                            timeRangeArray.append(TimeRangeModel(startDate: timeStart, endDate: timeEnd))
                                        }
                                        
                                        if(!self.isUserOnBreak){
                                            print(availableDates)
                                           for availableDate in availableDates{
                                            self.daysAvailableArray.append(BookingsModel(availableDay: availableDate, availableDaysModel: daysOfWeekAvailaiblityArray, timeRangeModel: timeRangeArray, serviceDuration: self.serviceDuration))
                                            self.updateCollectionView()
                                           }
                                       }
                                                           
                                        self.updateCollectionView()

                                    }
                            }
                        }
                    }
                    
                    
                   
                    
                    
                    
                    
                }
        }
        
        
        
       
        
    }
    
    func sortArray(){
        self.daysAvailableArray.sort(by: { $0.bookDate!.compare($1.bookDate!) == .orderedAscending })
    }
    
    func updateCollectionView () {
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }
    
}
