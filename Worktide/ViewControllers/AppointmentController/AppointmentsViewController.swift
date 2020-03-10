//
//  AppointmentsViewController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-16.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FSCalendar
import FirebaseFirestore
import FirebaseStorage
import MapKit
import MessageUI

class AppointmentsViewController:UITableViewController, AppointmentsDelegate, FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate{
    
    var appointmentsArray = [ServicerAppointmentsModel]()
    var arrayOfDatesWithBookings = [Date]()
    var selectedDate = Date().startOfDay
    
    var availableDates = [UserScheduleModel]()
    
    private let notLoggedInImage:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "appointmentIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let notLoggedInText:UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.center
        textView.text = "Sign in so you can see your upcoming appointments"
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        textView.numberOfLines = 0
        return textView
    }()
    
    private let loginButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign in", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setupNavigationBar()
        setupTableView()
        loadAppointmentsOfDate(selectedDate)
        
    }
    
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose, target: self, action: #selector(menuButtonTapped(sender:)))
        self.navigationItem.title = "Appointment"
        
        
 
    }
    
    
    //Collection View-----------------------------------------------------------------------------------
    
    func setupTableView(){
        
        let inset = UIEdgeInsets(top: 20, left: 0, bottom: 25, right: 0)
        tableView.contentInset = inset
        self.tableView.separatorStyle = .none
        
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.register(CalendarCell.self, forCellReuseIdentifier: "CalendarCell")
        tableView.register(AppointmentsTableCell.self, forCellReuseIdentifier: "AppointmentsCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")

    }
    
    
    /*override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0, 1:
            break
        default:
            let model = appointmentsArray[indexPath.row]
            let viewController = ViewAppointmentController()
            viewController.serviceTitle.text = model.serviceTitle
            viewController.timeLabel.text = model.serviceDateDisplay
            viewController.priceLabel.text = model.servicePrice
            viewController.usersName.text = model.otherName
            viewController.latitude = model.latitude
            viewController.longitude = model.longitude
            viewController.circleRadius = model.circleRadius
            viewController.usersPhoneNumber = model.usersPhoneNumber
            viewController.bookingID = model.bookingID
            viewController.customerID = model.customerID
            navigationController?.pushViewController(viewController, animated: true)
        }
    }*/
    
    //Table View Setup-------------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch appointmentsArray.count {
        case 0:
            return 3
        default:
            return appointmentsArray.count + 2
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
            cell.selectionStyle = .none
            
            cell.calendar.delegate = self
            cell.calendar.dataSource = self
            cell.calendar.reloadData()
            cell.calendar.select(selectedDate)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            cell.selectionStyle = .none
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.titleLabel.text = dateFormatter.string(from: selectedDate)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentsCell", for: indexPath) as! AppointmentsTableCell
            cell.selectionStyle = .none
            
            cell.appointmentsArray = appointmentsArray
            cell.availableDates = availableDates
            cell.selectedDate = selectedDate
            cell.delegate = self
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        switch indexPath.row {
        case 0:
            return 300
        case 1:
            return 50
        default:
            return 390
        }
        
    }
    
    
    //Calendar in CollectionView------------------------------------------------------------
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        loadAppointmentsOfDate(date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        for dates in availableDates {
            if(Calendar.current.isDate(dates.startDate!, inSameDayAs: date)){
                return .lightGray
            }
        }

        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        for dates in arrayOfDatesWithBookings{
            if(Calendar.current.isDate(dates, inSameDayAs:date) && date >= Date().startOfDay){
                return .white
            }
        }
        for dates in availableDates {
            if(Calendar.current.isDate(dates.startDate!, inSameDayAs: date)){
                return .black
            }
        }
        return .lightGray
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        for dates in arrayOfDatesWithBookings{
            if(Calendar.current.isDate(dates, inSameDayAs:date) && date >= Date().startOfDay){
                return .black
            }
        }
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        for dates in arrayOfDatesWithBookings{
            if(Calendar.current.isDate(dates, inSameDayAs:date) && date < Date().startOfDay){
                return 1
            }
        }
        
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [UIColor.lightGray]
    }
    
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        let maxedMonth = Calendar.current.date(byAdding: .month, value: 2, to: Date())!
        return maxedMonth
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        let minMonth = Calendar.current.date(byAdding: .month, value: -4, to: Date())!
        return minMonth
    }
    
    
    
    //Data Management-------------------------------------------------------
    
    func loadAppointmentsOfDate(_ date:Date){
        selectedDate = date
        appointmentsArray.removeAll()
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date)
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        let db = Firestore.firestore()
        db.collection("Bookings").whereField("startDate", isGreaterThanOrEqualTo: date).whereField("startDate", isLessThanOrEqualTo: nextDay!).whereField("servicer", isEqualTo: userID).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                self.updateTableView()
                return
            }
                
            for document in documents{
                let startDate = (document.get("startDate") as! Timestamp).dateValue()
                let servicePrice = document.get("servicePrice") as! String
                let serviceTitle = document.get("serviceTitle") as! String
                let customerID = document.get("customer") as! String
                let endDate = (document.get("endDate") as! Timestamp).dateValue()
                //let circleRadius = document.get("circleRadius") as! Double
                let latitude = document.get("latitude") as! Double
                let longitude = document.get("longitude") as! Double
                let bookingID = document.documentID
                let serviceAddress = document.get("serviceAddress") as? String
                
                db.collection("Users").document(customerID).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let usersName = document.get("usersName") as! String
                        let usersPhoneNumber = document.get("usersPhoneNumber") as! String
                        let photoURL = document.get("userPhotoURL") as? String
                        
                        self.appointmentsArray.append(ServicerAppointmentsModel(tableView:self.tableView,bookingID: bookingID, serviceTitle: serviceTitle, otherName: usersName, otherPhoneNumber: usersPhoneNumber, servicePrice: servicePrice, startDate: startDate, endDate: endDate, serviceAddress: serviceAddress, location: CLLocation(latitude: latitude, longitude: longitude), userImageString: photoURL))
                        self.sortArray()
                        self.updateTableView()
                        
                    } else {
                        self.removeSpinner()
                        self.updateTableView()
                        print("Document does not exist")
                    }
                }
                
                
            }
            
        }
    }
    
    
    func getData(){
        
        let userID = (Auth.auth().currentUser?.uid)!
        let db = Firestore.firestore()
        
        db.collection("Bookings").whereField("servicer", isEqualTo: userID).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            for document in documents{
                let startDate = (document.get("startDate") as! Timestamp).dateValue()
                self.arrayOfDatesWithBookings.append(startDate)
                self.updateTableView()
            }
        }
        
        
        db.collection("Users").document(userID).collection("MySchedule").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            let next90DaysArray = HelperForCalculating.setupNext90Days()
            var userAvailabilityModelArray = [UserAvailabilityModel]()
            
            for document in documents{
                let dayOfWeekString = document.documentID
                let startTimeString = document.get("startTime") as? String
                let endTimeString = document.get("endTime") as? String
                
                userAvailabilityModelArray.append(UserAvailabilityModel(dayOfWeekString: dayOfWeekString, startTimeString: startTimeString, endTimeString: endTimeString))
            }
            
            self.availableDates = HelperForCalculating.calculateAvailableDays(next90Days: next90DaysArray, userAvailabilityModel: userAvailabilityModelArray)
            
            self.updateTableView()
            
        }
        
        db.collection("Users").document(userID).collection("Exceptions").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            
            for document in documents{
                let exceptionID = document.get("exceptionID") as! Int
                let date = (document.get("date") as! Timestamp).dateValue()
                
                //0 = booked off, 1 = changed time
                if(exceptionID == 0){
                    self.availableDates = self.availableDates.filter{ !(Calendar.current.isDate($0.startDate!, inSameDayAs: date)) }
                } else {
                    let startTime = document.get("startTime") as? String
                    let endTime = document.get("endTime") as? String
                    //Monday is not important just used for the model
                    let model = UserAvailabilityModel(dayOfWeekString: "Monday", startTimeString: startTime, endTimeString: endTime)
                    
                    let startDate = Calendar.current.date(bySettingHour: model.startTimeHour, minute: model.startTimeMin, second: 0, of: date)
                    let endDate = Calendar.current.date(bySettingHour: model.endTimeHour, minute: model.endTimeMin, second: 0, of: date)
                    
                    if let row = self.availableDates.lastIndex(where: {Calendar.current.isDate($0.startDate!, inSameDayAs: date)}) {
                        self.availableDates[row] = UserScheduleModel(startDate: startDate, endDate: endDate)
                        self.updateTableView()
                    } else {
                        self.availableDates.append(UserScheduleModel(startDate: startDate, endDate: endDate))
                        self.updateTableView()
                    }
                }
                
            }
            
            
            self.updateTableView()
            
        }
        
    }
    
    func sortArray(){
        self.appointmentsArray.sort(by: { $0.serviceDate!.compare($1.serviceDate!) == .orderedAscending })
        
    }
    
    func updateTableView() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    //Button listeners--------------------------------------------------------------------------------------------
    
    @objc func buttonAction(sender: UIButton!) {
        switch sender {
        case loginButton:
            let viewController = LoginController()
            viewController.dismissViewController = true
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overFullScreen
            self.present(navigationController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            HelperViewTransitions.showAvailabilityControllerScheduler(currentViewController:self)
        default:
            break
        }
    }
    
    func didTapCell(_ indexPath:IndexPath) {
        
        switch appointmentsArray.count {
        case 0:
            //no data
            showAlert(isDefaultCell: true, indexPath: indexPath)
        default:
            //with data
            switch indexPath.row {
            case appointmentsArray.count:
                showAlert(isDefaultCell: true, indexPath: indexPath)
            default:
                showAlert(isDefaultCell: false, indexPath: indexPath)
            }
        }
        

    }
    
//DO Functions-------------------------------------------------------------------------
    
    func showAlert(isDefaultCell:Bool, indexPath:IndexPath){
        if(isDefaultCell){
            if(selectedDate.startOfDay >= Date().startOfDay){
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                        
                if(availableDates.contains(where:{Calendar.current.isDate(selectedDate, inSameDayAs: $0.startDate!)})){
                    //selected date is available
                    alert.addAction(UIAlertAction(title: "Close Remaining Spots", style: .default, handler: { (_) in
                        let viewController = ScheduleExceptionController()
                        viewController.viewToShow = 0
                        viewController.dateSelected = self.selectedDate
                        let navigationController = UINavigationController(rootViewController: viewController)
                        alert.dismiss(animated: true, completion: {
                            self.present(navigationController, animated: true)
                        })
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Change Hours", style: .default, handler: { (_) in
                        let viewController = ScheduleExceptionController()
                        viewController.viewToShow = 2
                        viewController.dateSelected = self.selectedDate
                        let navigationController = UINavigationController(rootViewController: viewController)
                        alert.dismiss(animated: true, completion: {
                            self.present(navigationController, animated: true)
                        })
                    }))
                    
                } else {
                    alert.addAction(UIAlertAction(title: "Open Spot", style: .default, handler: { (_) in
                        let viewController = ScheduleExceptionController()
                        viewController.viewToShow = 1
                        viewController.dateSelected = self.selectedDate
                        let navigationController = UINavigationController(rootViewController: viewController)
                        alert.dismiss(animated: true, completion: {
                            self.present(navigationController, animated: true)
                        })
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Change Availability", style: .default, handler: { (_) in
                        alert.dismiss(animated: true, completion: {
                            HelperViewTransitions.showAvailabilityControllerScheduler(currentViewController:self)
                        })
                    }))
                }
            
                
                alert.addAction(UIAlertAction(title: "Email Support", style: .default, handler: { (_) in
                    self.sendEmail("No Booking ID")
                }))
            
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                }
        } else {
            let model = appointmentsArray[indexPath.row]
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            if(model.serviceDate!.startOfDay >= Date().startOfDay - (86400 * 2)){//86400 seconds/day
                alert.addAction(UIAlertAction(title: "Contact \(model.otherName!)", style: .default, handler: { (_) in
                    
                    if(MFMessageComposeViewController.canSendText()){
                        self.showCallingAlert(model.userPhoneNumber!)
                    } else {
                        let phoneNumber = model.userPhoneNumber!.filter("0123456789.".contains)
                        let url: NSURL = URL(string: "TEL://\(phoneNumber)")! as NSURL
                        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                    }
                    
                }))
            }
            
            
            alert.addAction(UIAlertAction(title: "Open in Maps", style: .default, handler: { (_) in
                self.openMapForPlace(model.serviceLocation, model.serviceTitle!)
            }))
            
            
            alert.addAction(UIAlertAction(title: "Email Support", style: .default, handler: { (_) in
                self.sendEmail(model.bookingID!)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    
    }
    
    func openMapForPlace(_ location:CLLocation?, _ mapItemName:String) {

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = mapItemName
        mapItem.openInMaps(launchOptions: options)
    }
    
    func sendEmail(_ bookingID:String){
    
        if !MFMailComposeViewController.canSendMail() {
            self.showEmailAddress()
        } else {
            emailSetup(bookingID)
        }
        
    }
    
    func showCallingAlert(_ phoneNumber:String){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Call \(phoneNumber)", style: .default, handler: { (_) in
            let phoneNumber = phoneNumber.filter("0123456789.".contains)
            let url: NSURL = URL(string: "TEL://\(phoneNumber)")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Text \(phoneNumber)", style: .default, handler: { (_) in
             if (MFMessageComposeViewController.canSendText()) {
                let phoneNumber = phoneNumber.filter("0123456789.".contains)
                let controller = MFMessageComposeViewController()
                controller.recipients = [phoneNumber]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showEmailAddress() {
        let alert = UIAlertController(title: "Email us at", message: "worktide@outlook.com", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    func emailSetup(_ bookingID:String) {
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self 
        // Configure the fields of the interface.
        composeVC.setToRecipients(["worktide@outlook.com"])
        composeVC.setSubject("Booking Support")
        composeVC.setMessageBody("Booking ID: \(bookingID)\n", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
}

class TitleCell:UITableViewCell{
    
    public let titleLabel:UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        textView.numberOfLines = 0
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CalendarCell:UITableViewCell{
    
    public let calendar:FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)!
        calendar.today = nil
        calendar.backgroundColor = .white
        calendar.placeholderType = .none
        return calendar
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        self.addSubview(calendar)
        calendar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        calendar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        calendar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 300).isActive = true
        calendar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        
        for labels in calendar.calendarWeekdayView.weekdayLabels{
            labels.textColor = .black
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AppointmentsTableCell:UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var appointmentsArray = [ServicerAppointmentsModel]()
    var availableDates = [UserScheduleModel]()
    var selectedDate = Date()
    
    var delegate: AppointmentsDelegate?
    
    public let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCollectionView()
    }
    
    func setupCollectionView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        
        collectionView.register(AppointmentsCollectionCell.self, forCellWithReuseIdentifier: "AppointmentsCollectionCell")
        collectionView.register(EnableOrDisableDateCell.self, forCellWithReuseIdentifier: "EnableOrDisableCell")
        
        self.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive  = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 25, bottom: 0, right: 25)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch appointmentsArray.count {
        case 0:
            return 1
        default:
            return appointmentsArray.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppointmentsCollectionCell", for: indexPath) as! AppointmentsCollectionCell
        
        let enableOrDisableCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EnableOrDisableCell", for: indexPath) as! EnableOrDisableDateCell
        
        //set availability time
        let availableDay = availableDates.first(where: {Calendar.current.isDate(selectedDate, inSameDayAs: $0.startDate!)})
        if availableDay != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            
            let timeStart = dateFormatter.string(from: availableDay!.startDate!)
            let timeEnd = dateFormatter.string(from: availableDay!.endDate!)
            
            enableOrDisableCell.extraTextLabel.text = "Available to book from\n\(timeStart)\nto\n\(timeEnd)"
        } else {
            enableOrDisableCell.extraTextLabel.text = ""
        }
        
        //Set title and cell color
        if availableDates.contains(where: { Calendar.current.isDate(selectedDate, inSameDayAs: $0.startDate!)}) {
             // found
            enableOrDisableCell.titleLabel.text = "You are available for this date to be booked."
            enableOrDisableCell.backgroundColor = .systemGreen
            enableOrDisableCell.optionsButton.isHidden = false
        } else {
             // not
            if(selectedDate < Date().startOfDay){
                enableOrDisableCell.titleLabel.text = "This date has passed."
                enableOrDisableCell.backgroundColor = .black
                enableOrDisableCell.optionsButton.isHidden = true
            } else {
                enableOrDisableCell.titleLabel.text = "You are not available on this date."
                enableOrDisableCell.backgroundColor = .lightGray
                enableOrDisableCell.optionsButton.isHidden = false
            }
        }
        
        //set subTitle
        let appointmentsInToday = appointmentsArray.filter{Calendar.current.isDate(selectedDate, inSameDayAs: $0.serviceDate!)}
        enableOrDisableCell.subTitleLabel.text = "\(appointmentsInToday.count) appointment(s)"
        
        switch appointmentsArray.count {
        case 0:
            return enableOrDisableCell
        default:
            switch indexPath.row {
            case appointmentsArray.count:
                return enableOrDisableCell
            default:
                cell.setupViews()
                let model = appointmentsArray[indexPath.row]
                cell.titleLabel.text = "\(model.serviceTitle!) For \(model.otherName!)"
                cell.payLabel.text = model.servicePrice
                cell.timeLabel.text = model.serviceTime
                cell.durationLabel.text = model.serviceDuration
                cell.locationLabel.text = model.serviceLocationText
                cell.userImage.image = model.userImage
                if(model.userImage == nil){
                    cell.userImage.layer.borderWidth = 0
                } else {
                    cell.userImage.layer.borderWidth = 1
                }
                
                return cell
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapCell(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 50, height: 380)
    }
    
    override func prepareForReuse() {
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AppointmentsCollectionCell:UICollectionViewCell{
    
    public let titleLabel:UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 28)
        textView.numberOfLines = 2
        textView.adjustsFontSizeToFitWidth = true
        textView.text = "Home Cleaning With Kristofer"
        return textView
    }()
    
    public let userImage:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    public let payIcon: UIImageView = {
        let image = UIImage(named: "priceIcon")?.imageWithColor(tintColor: UIColor.white)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    public let payLabel:UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textView.numberOfLines = 1
        textView.adjustsFontSizeToFitWidth = true
        textView.text = "$30"
        return textView
    }()
    
    public let timeIcon: UIImageView = {
        let image = UIImage(named: "timeIcon")?.imageWithColor(tintColor: UIColor.white)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    public let timeLabel:UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textView.numberOfLines = 1
        textView.adjustsFontSizeToFitWidth = true
        textView.text = "4:00 AM"
        return textView
    }()
    
    public let durationIcon: UIImageView = {
        let image = UIImage(named: "durationIcon")?.imageWithColor(tintColor: UIColor.white)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    public let durationLabel:UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textView.numberOfLines = 1
        textView.adjustsFontSizeToFitWidth = true
        textView.text = "1 hour and 15 mins"
        return textView
    }()
    
    public let locationIcon: UIImageView = {
        let image = UIImage(named: "navigationMarker")?.imageWithColor(tintColor: UIColor.white)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    public let locationLabel:UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textView.numberOfLines = 1
        textView.adjustsFontSizeToFitWidth = true
        textView.text = "1730 Leila Ave"
        return textView
    }()
    
    public let optionsButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OPTIONS", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBlue
        setupViews()
        
    }
    
    
    func setupViews(){
        
        self.addSubview(userImage)
        userImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        userImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: userImage.leadingAnchor, constant: -10).isActive = true
        
        self.addSubview(payIcon)
        payIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        payIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
        payIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        payIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.addSubview(payLabel)
        payLabel.leadingAnchor.constraint(equalTo: payIcon.trailingAnchor, constant: 15).isActive = true
        payLabel.centerYAnchor.constraint(equalTo: payIcon.centerYAnchor).isActive = true
        
        self.addSubview(timeIcon)
        timeIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        timeIcon.topAnchor.constraint(equalTo: payIcon.bottomAnchor, constant: 15).isActive = true
        timeIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        timeIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(timeLabel)
        timeLabel.leadingAnchor.constraint(equalTo: payLabel.leadingAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor).isActive = true
        
        self.addSubview(durationIcon)
        durationIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        durationIcon.topAnchor.constraint(equalTo: timeIcon.bottomAnchor, constant: 15).isActive = true
        durationIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        durationIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(durationLabel)
        durationLabel.leadingAnchor.constraint(equalTo: payLabel.leadingAnchor).isActive = true
        durationLabel.centerYAnchor.constraint(equalTo: durationIcon.centerYAnchor).isActive = true
        
        self.addSubview(locationIcon)
        locationIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        locationIcon.topAnchor.constraint(equalTo: durationIcon.bottomAnchor, constant: 15).isActive = true
        locationIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        locationIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(locationLabel)
        locationLabel.leadingAnchor.constraint(equalTo: payLabel.leadingAnchor).isActive = true
        locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor).isActive = true
        
        self.addSubview(optionsButton)
        optionsButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        optionsButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
        optionsButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        optionsButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.23
        self.layer.shadowRadius = 4
        
        userImage.layer.cornerRadius = userImage.frame.height / 2.0
        userImage.clipsToBounds = true
        
        self.layoutIfNeeded()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EnableOrDisableDateCell:UICollectionViewCell{
    
    public let titleLabel:UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 28)
        textView.numberOfLines = 2
        textView.adjustsFontSizeToFitWidth = true
        return textView
    }()
    
    public let subTitleLabel:UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        textView.numberOfLines = 2
        textView.adjustsFontSizeToFitWidth = true
        return textView
    }()
    
    public let extraTextLabel:UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.textAlignment = NSTextAlignment.left
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textView.numberOfLines = 0
        textView.adjustsFontSizeToFitWidth = true
        return textView
    }()

    public let optionsButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OPTIONS", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = .darkGray
        setupViews()
        
    }
    
    
    func setupViews(){
        
        self.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
        self.addSubview(subTitleLabel)
        subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
        self.addSubview(optionsButton)
        optionsButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        optionsButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
        optionsButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        optionsButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        
        self.addSubview(extraTextLabel)
        extraTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        extraTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        extraTextLabel.bottomAnchor.constraint(equalTo: optionsButton.topAnchor, constant: -10).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.23
        self.layer.shadowRadius = 4
        
        self.layoutIfNeeded()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol AppointmentsDelegate {
    func didTapCell(_  indexPath: IndexPath)
}
