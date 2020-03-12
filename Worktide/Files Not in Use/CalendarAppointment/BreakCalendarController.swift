//
//  BreakCalendarController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-20.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import FSCalendar
import FirebaseFirestore
import FirebaseAuth

class BreakCalendarController:UIViewController, FSCalendarDelegate, FSCalendarDelegateAppearance{
    
    var selectedDate = [Date]()
    
    private let calendar:FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.appearance.titleDefaultColor = .lightGray
        calendar.today = nil
        calendar.allowsMultipleSelection = true
        calendar.placeholderType = .none
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)!
        return calendar
    }()
    
    private let doneBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitle("Set Break",for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCalendar()
        setupView()
        
    }
    
    func setupNavigation(){
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        title = "Temporary Break"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backIconBlack")!.withRenderingMode(.alwaysOriginal),style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
        
    }
    
    func setupCalendar(){
        calendar.delegate = self
        for dates in selectedDate{
            calendar.select(dates)
        }
        
    }
    
    
    func setupView(){
        
        view.backgroundColor = .white
        
        view.addSubview(calendar)
        calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        view.addSubview(doneBtn)
        doneBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        doneBtn.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        doneBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate.append(date)
        doneBtn.isHidden = false
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = selectedDate.filter { $0 != date }
        doneBtn.isHidden = false
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool{
        let lastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let releaseDate = Date(timeIntervalSince1970: 1577408400)
        if(date < lastDate! || date < releaseDate){
            return false
        }else{
            return true
        }
    }

    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let lastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let releaseDate = Date(timeIntervalSince1970: 1577408400)
        if(date < lastDate! || date < releaseDate){
            return UIColor.lightGray
        }else{
            return UIColor.black
        }
    }
    
    @objc func doneButton(sender: UIButton!) {
        let alert = UIAlertController(title: "Are you sure?", message: "Make sure to notify anyone that has an appointment with you on these dates", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            
            alert.dismiss(animated: true, completion: {
                let alert = UIAlertController(title: nil, message: "Setting breaks...", preferredStyle: .alert)

                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.style = UIActivityIndicatorView.Style.gray
                loadingIndicator.startAnimating();

                alert.view.addSubview(loadingIndicator)
                self.present(alert, animated: true, completion: nil)
                
                guard let userID = Auth.auth().currentUser?.uid else { return }
                let db = Firestore.firestore()
                db.collection("Users").document(userID).collection("Breaks").document("Breaks").setData([
                    "breakArray":self.selectedDate
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
        
        
        self.present(alert, animated: true, completion: nil)
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
            break
        default:
            break
        }
    }
}
