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
    var selectedDate = Date()
    
    var doesUserHaveCalendar = false
    var availableDates = [Date]()
    
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
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose, target: self, action: #selector(menuButtonTapped(sender:)))
        self.title = "Appointments"
        
        
 
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
        
        /*let footerView = collectionView!.cellForItem(at: IndexPath(row: 0, section: 0)) as! AppointmentsLoadingView
        footerView.loadView.isHidden = false
        footerView.loadingText.isHidden = false
        footerView.loadView.startAnimating()*/
        
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
                        
                        self.appointmentsArray.append(ServicerAppointmentsModel(bookingID: bookingID, serviceTitle: serviceTitle, otherName: usersName, otherPhoneNumber: usersPhoneNumber, servicePrice: servicePrice, startDate: startDate, endDate: endDate, serviceAddress: serviceAddress, location: CLLocation(latitude: latitude, longitude: longitude)))
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
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        for dates in availableDates {
            if(Calendar.current.isDate(dates, inSameDayAs: date)){
                return .lightGray
            }
        }

        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        for dates in arrayOfDatesWithBookings{
            if(Calendar.current.isDate(dates, inSameDayAs:date) && date > Date()){
                return .white
            }
        }
        for dates in availableDates {
            if(Calendar.current.isDate(dates, inSameDayAs: date)){
                return .black
            }
        }
        return .lightGray
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        for dates in arrayOfDatesWithBookings{
            if(Calendar.current.isDate(dates, inSameDayAs:date) && date > Date()){
                return .black
            }
        }
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        for dates in arrayOfDatesWithBookings{
            if(Calendar.current.isDate(dates, inSameDayAs:date) && date < Date()){
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
    
    func getData(){
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
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
        
        //set up next 3 months
        var next90DaysArray = [Date]()
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        for _ in 1 ... 90 {
            next90DaysArray.append(date)
            date = cal.date(byAdding: .day, value: +1, to: date)!
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        db.collection("Users").document(userID).collection("MySchedule").getDocuments() { (querySnapshot, err) in
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
                    for day in next90DaysArray{
                        let dayInString = dateFormatter.string(from: day)
                        
                        if(availableDays.contains(dayInString)){
                            self.availableDates.append(day)
                        }
                    }
                    
                    //reload the collectionview
                    self.updateTableView()
                    
                }
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
            let viewController = AddTimeBlockController()
            self.present(viewController, animated:true)
        default:
            break
        }
    }
    
    func didTapCell(_ indexPath:IndexPath) {
        
        switch appointmentsArray.count {
        case 0:
            //no data
            break
        default:
            //with data
            switch indexPath.row {
            case appointmentsArray.count:
                break
            default:
                let model = appointmentsArray[indexPath.row]
                
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Contact \(model.otherName!)", style: .default, handler: { (_) in
                    
                    if(MFMessageComposeViewController.canSendText()){
                        self.showCallingAlert(model.userPhoneNumber!)
                    } else {
                        let phoneNumber = model.userPhoneNumber!.filter("0123456789.".contains)
                        let url: NSURL = URL(string: "TEL://\(phoneNumber)")! as NSURL
                        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                    }
                    
                }))
                
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
        

    }
    
//DO Functions-------------------------------------------------------------------------
    
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
    var availableDates = [Date]()
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
        
        for date in availableDates{
            if(Calendar.current.isDate(selectedDate, inSameDayAs: date)){
                enableOrDisableCell.titleLabel.text = "You are available for this date to be booked."
                enableOrDisableCell.backgroundColor = .systemGreen
                break
            } else {
                if(selectedDate < Date()){
                    enableOrDisableCell.titleLabel.text = "This date has passed."
                    enableOrDisableCell.backgroundColor = .black
                } else {
                    enableOrDisableCell.titleLabel.text = "You are not available on this date."
                    enableOrDisableCell.backgroundColor = .lightGray
                }
                
            }
        }
        
        
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
        
        self.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        
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
        textView.text = "0 appointments for this day."
        return textView
    }()
    
    public let extraTextLabel:UILabel = {
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

    public let optionsButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OPTIONS", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
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
