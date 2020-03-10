//
//  ServiceDurationController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-07.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class ServiceSchedulingController:UITableViewController{
    
    var createServiceModel:CreateServiceModel!
    var usingMintues = true
    var hideTableView = false
    
    var scheduleArray = ["Kristofer's Schedule", "Ryan's Schedule", "Franco's Schedule"]
    var selectedCell = [IndexPath]()
    
    //Item Initialization--------------------------------------------
    
    private let containerLayout: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let setOptionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Use with schedule"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let createScheduleDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Turn this on for services that are appointment based."
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let learnMoreButton:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.text = "Learn more"
        label.textColor = .systemBlue
        return label
    }()
    
    private let switchButton:UISwitch = {
        let switchBtn = UISwitch()
        switchBtn.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        switchBtn.translatesAutoresizingMaskIntoConstraints = false
        switchBtn.isOn = true
        return switchBtn
    }()
    
    private let estimatedDurationLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create schedule"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
     private let setDurationLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Estimated Duration"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let durationValue:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5 mins"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let durationDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Set how long it will take you to finish."
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let durationSlider:UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 5
        slider.minimumValue = 5
        slider.maximumValue = 600
        slider.addTarget(self, action:#selector(sliderValueDidChange(sender:)), for: .valueChanged)
        return slider
    }()
    
    private let switchValues:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.text = "Set to days"
        label.textColor = .systemBlue
        return label
    }()
    
    private let linkScheduleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Link Spots"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let linkScheduleDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Link a spot for every customer you can take at the same time. You could also use this to seperate employee schedule."
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let linkSchedulerLearnMore:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.text = "Learn more"
        label.textColor = .systemBlue
        return label
    }()
    
    //IOS Functions------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
        setupTableView()
        getData()
        
    }
    
    //ViewSetup---------------------------------------------
    
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(menuButtonTapped))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "Scheduling"
    }
    
    func setupView(){
        view.backgroundColor = .white
        
        self.tableView.tableHeaderView = containerLayout
        self.tableView.tableHeaderView?.isUserInteractionEnabled = true
        containerLayout.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerLayout.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        containerLayout.addSubview(setOptionLabel)
        containerLayout.addSubview(createScheduleDescription)
        containerLayout.addSubview(learnMoreButton)
        containerLayout.addSubview(switchButton)
        
        setOptionLabel.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        setOptionLabel.topAnchor.constraint(equalTo: containerLayout.topAnchor, constant: 30).isActive = true
        setOptionLabel.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor, constant: -15).isActive = true
        
        createScheduleDescription.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        createScheduleDescription.topAnchor.constraint(equalTo: setOptionLabel.bottomAnchor, constant: 10).isActive = true
        createScheduleDescription.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor, constant: -15).isActive = true
        
        learnMoreButton.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        learnMoreButton.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -50).isActive = true
        learnMoreButton.topAnchor.constraint(equalTo: createScheduleDescription.bottomAnchor, constant: 10).isActive = true
        learnMoreButton.addTapGestureRecognizer{
            HelperViewTransitions.showLearnMoreViewController(viewCode: 3, currentViewController: self)
        }
        
        switchButton.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -25).isActive = true
        switchButton.centerYAnchor.constraint(equalTo: setOptionLabel.centerYAnchor).isActive = true
        
        containerLayout.addSubview(setDurationLabel)
        containerLayout.addSubview(durationValue)
        containerLayout.addSubview(durationDescription)
        containerLayout.addSubview(durationSlider)
        containerLayout.addSubview(switchValues)
        
        setDurationLabel.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        setDurationLabel.trailingAnchor.constraint(equalTo: durationValue.trailingAnchor, constant: -15).isActive = true
        setDurationLabel.topAnchor.constraint(equalTo: learnMoreButton.bottomAnchor, constant: 50).isActive = true
        
        durationValue.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -25).isActive = true
        durationValue.centerYAnchor.constraint(equalTo: setDurationLabel.centerYAnchor).isActive = true
        
        durationDescription.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        durationDescription.topAnchor.constraint(equalTo: setDurationLabel.bottomAnchor, constant: 10).isActive = true
        durationDescription.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -25).isActive = true
        
        durationSlider.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        durationSlider.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -25).isActive = true
        durationSlider.topAnchor.constraint(equalTo: durationDescription.bottomAnchor, constant: 30).isActive = true
        
        switchValues.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        switchValues.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -50).isActive = true
        switchValues.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 15).isActive = true
        switchValues.addTapGestureRecognizer{
            if(self.usingMintues){
                //switched to days
                self.usingMintues = false
                self.switchValues.text = "Set to mintues"
                self.durationSlider.minimumValue = 1
                self.durationSlider.maximumValue = 15
                self.durationValue.text = "1 day"
                self.durationSlider.value = 1
            } else {
                //switched to mintues
                self.switchValues.text = "Set to days"
                self.usingMintues = true
                self.durationSlider.minimumValue = 5
                self.durationSlider.maximumValue = 600
                self.durationValue.text = "5 min"
                self.durationSlider.value = 5
            }
        }
        
        containerLayout.addSubview(linkScheduleLabel)
        containerLayout.addSubview(linkScheduleDescription)
        containerLayout.addSubview(linkSchedulerLearnMore)
        
        linkScheduleLabel.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        linkScheduleLabel.topAnchor.constraint(equalTo: switchValues.bottomAnchor, constant: 40).isActive = true
        linkScheduleLabel.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -25).isActive = true
        
        linkScheduleDescription.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        linkScheduleDescription.topAnchor.constraint(equalTo: linkScheduleLabel.bottomAnchor, constant: 10).isActive = true
        linkScheduleDescription.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -25).isActive = true
        
        linkSchedulerLearnMore.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        linkSchedulerLearnMore.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -50).isActive = true
        linkSchedulerLearnMore.topAnchor.constraint(equalTo: linkScheduleDescription.bottomAnchor, constant: 10).isActive = true
        linkSchedulerLearnMore.addTapGestureRecognizer{
            HelperViewTransitions.showLearnMoreViewController(viewCode: 4, currentViewController: self)
        }
        
        ///ADD TO LAST VIEW
        linkSchedulerLearnMore.bottomAnchor.constraint(equalTo: containerLayout.bottomAnchor, constant: -25).isActive = true
        
        
        ///Change text of durationDescription if varied pricing
        switch createServiceModel.variedPricing {
        case true:
            durationDescription.text = durationDescription.text! + " Don't worry you can set a more accurate duration when you know more about the work."
        default:
            break
        }
        
        
    }
    
    //TableView------------------------------------------------
    
    func setupTableView(){
        self.tableView.register(ScheduleListCell.self, forCellReuseIdentifier: "defaultCell")
        self.tableView.register(ButtonCell.self, forCellReuseIdentifier: "buttonCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        self.tableView.contentInset = insets
        self.tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(hideTableView){
            return 0
        } else {
            return scheduleArray.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case scheduleArray.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.button.backgroundColor = .systemBlue
            cell.button.setTitle("Create a spot", for: .normal)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as! ScheduleListCell
            cell.title.text = scheduleArray[indexPath.row]
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case scheduleArray.count:
            //button selected
            HelperViewTransitions.showAvailabilityControllerScheduler(currentViewController:self)
        default:
            
            if selectedCell.contains(indexPath) {
                let cell = tableView.cellForRow(at: indexPath) as! ScheduleListCell
                cell.title.textColor = .black
                cell.containerLayout.backgroundColor = .clear
                cell.containerLayout.layer.borderColor =  UIColor.black.cgColor
                selectedCell = selectedCell.filter{$0 != indexPath}
            } else {
                selectedCell.append(indexPath)
                
                let cell = tableView.cellForRow(at: indexPath) as! ScheduleListCell
                cell.title.textColor = .white
                cell.containerLayout.backgroundColor = .lightGray
                cell.containerLayout.layer.borderColor = UIColor.white.cgColor
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func updateTableView(){
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    //Data mangaement-----------------------------------------
    
    func getData(){
        self.updateTableView()
    }
    
    //Listeners------------------------------------------------
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            
            let selectedArray = selectedCell.map {scheduleArray[$0.row]}
            
            if selectedArray.count == 0 && switchButton.isOn{
                switchButton.setOn(false, animated: true)
                hideCollectionView()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showServiceExtraInformationController()
                }
            } else {
                self.showServiceExtraInformationController()
            }
            
        default:
            break
        }
    }
    
    @objc func sliderValueDidChange(sender: UISlider) {
        
        if usingMintues {
            //rounded to values of 5
            let roundedValue = round(sender.value / 5) * 5
            sender.value = roundedValue
            
            durationValue.text = Int(sender.value).minutesToWords()
        } else {
            durationValue.text = Int(sender.value).daysToWords()
        }
        
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            showCollectionView()
        } else {
            hideCollectionView()
        }
    }
    
    //Do Functions-------------------------------------------------
    
    func hideCollectionView(){
        linkScheduleLabel.isHidden = true
        linkScheduleDescription.isHidden = true
        linkSchedulerLearnMore.isHidden = true
        self.hideTableView = true
        self.updateTableView()
    }
    
    func showCollectionView(){
        linkScheduleLabel.isHidden = false
        linkScheduleDescription.isHidden = false
        linkSchedulerLearnMore.isHidden = false
        self.hideTableView = false
        self.updateTableView()
    }
    
    func showServiceExtraInformationController(){
        if(usingMintues){
            createServiceModel.estimatedDuration = Int(durationSlider.value)
        } else {
            createServiceModel.estimatedDuration = Int(durationSlider.value * 1440)
        }
        createServiceModel.scheduleArray = selectedCell.map {scheduleArray[$0.row]}

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let viewController = ServiceExtraInformationController(collectionViewLayout: flowLayout)
        viewController.createServiceModel = createServiceModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

class ScheduleListCell: UITableViewCell {
    
    public let containerLayout: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 10
        return view
    }()
    
    public let title:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        self.backgroundColor = .white
        
        self.addSubview(containerLayout)
        self.addSubview(title)
        
        containerLayout.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        containerLayout.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        containerLayout.heightAnchor.constraint(equalToConstant: 50).isActive = true
        containerLayout.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        title.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 15).isActive = true
        title.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -15).isActive = true
        title.centerYAnchor.constraint(equalTo: containerLayout.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
