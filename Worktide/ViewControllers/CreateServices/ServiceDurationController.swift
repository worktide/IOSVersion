//
//  ServiceDurationController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-07.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class ServiceDurationController:UIViewController{
    
    var delegate: ChangeServiceDelegate?
    var fromChangeService = false
    
    private let learnMoreButton:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Learn how we schedule appointments"
        label.textColor = .systemBlue
        label.isHidden = true
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        return label
    }()
    
    public let timeShowLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "15 min"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 28)!
        return label
    }()
    
    public let durationPicker:UIDatePicker = {
        let date = Calendar.current.date(bySettingHour:0, minute: 15, second: 0, of: Date())!
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .countDownTimer
        datePicker.setDate(date, animated: true)
        datePicker.addTarget(self, action: #selector(getTime(sender:)), for: .valueChanged)
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
        
        //default value
        if(!fromChangeService){
            InputDetails.details.serviceDuration = 15
        }
    }
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .always
        title = "Estimated Duration"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(menuButtonTapped))
    }
    
     func setupView(){
        view.backgroundColor = .white
        
        view.addSubview(durationPicker)
        durationPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        durationPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        durationPicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(timeShowLabel)
        timeShowLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeShowLabel.bottomAnchor.constraint(equalTo: durationPicker.topAnchor, constant: -25).isActive = true
        
        view.addSubview(learnMoreButton)
        learnMoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        learnMoreButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        learnMoreButton.topAnchor.constraint(equalTo: durationPicker.bottomAnchor, constant: 25).isActive = true
    }
    
    @objc func getTime(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone.current
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: sender.date)
        let minutes = calendar.component(.minute, from: sender.date)

        InputDetails.details.serviceDuration = (hour * 60) + minutes
        
        //set text
        if(hour == 0){
           timeShowLabel.text = String(minutes) + " min"
        } else {
            if(hour == 1){
                timeShowLabel.text = String(hour) + " hour " + String(minutes) + " min"
            } else {
                timeShowLabel.text = String(hour) + " hours " + String(minutes) + " min"
            }
        }
        
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            if(fromChangeService){
                delegate?.changeServiceDuration(value: InputDetails.details.serviceDuration!)
                self.dismiss(animated: true, completion: nil)
            } else {
                let viewController = ServiceDescriptionController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
        default:
            break
        }
    }
}
