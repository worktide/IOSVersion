//
//  QuestionsController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-26.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit

class QuestionsController: UITableViewController, UITextFieldDelegate{
    
    var createServiceModel:CreateServiceModel!
    
    var questionArray = [""]
    var MAX_AMOUNT_OF_QUESTIONS = 4
    var hideTableViewRows = false
    
    private let containerLayout: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let setOptionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Set Varied Pricing"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let variedPricingDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The customer will not be able to book with you until you have given a price quotation."
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let learnMoreButton:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.text = "Learn More"
        label.textColor = .systemBlue
        return label
    }()
    
    private let switchButton:UISwitch = {
        let switchBtn = UISwitch()
        switchBtn.translatesAutoresizingMaskIntoConstraints = false
        switchBtn.isOn = true
        switchBtn.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        return switchBtn
    }()
    
    private let questionsLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Questions for customer"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let questionDescription:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Get detailed information about what the customer needs by setting your questions. "
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    //TODO ADD DESCRIPTION FOR VARIED PRICING AND QUESTIONS FOR CUSTOMER
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        setupTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableView.tableHeaderView?.layoutIfNeeded()
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
    }

    func setupNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        title = "Custom Questions"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(menuButtonTapped))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setupViews(){
        
        self.tableView.tableHeaderView = containerLayout
        self.tableView.tableHeaderView?.isUserInteractionEnabled = true
        containerLayout.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerLayout.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        containerLayout.addSubview(switchButton)
        containerLayout.addSubview(setOptionLabel)
        containerLayout.addSubview(variedPricingDescription)
        containerLayout.addSubview(learnMoreButton)
        
        switchButton.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -25).isActive = true
        switchButton.topAnchor.constraint(equalTo: setOptionLabel.topAnchor).isActive = true
        
        setOptionLabel.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        setOptionLabel.topAnchor.constraint(equalTo: containerLayout.topAnchor, constant: 30).isActive = true
        setOptionLabel.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor, constant: -10).isActive = true
        
        variedPricingDescription.topAnchor.constraint(equalTo: setOptionLabel.bottomAnchor, constant: 5).isActive = true
        variedPricingDescription.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        variedPricingDescription.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor, constant: -10).isActive = true
        
        learnMoreButton.topAnchor.constraint(equalTo: variedPricingDescription.bottomAnchor, constant: 5).isActive = true
        learnMoreButton.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        learnMoreButton.addTapGestureRecognizer{
            HelperViewTransitions.showLearnMoreViewController(viewCode:1, currentViewController: self)
        }
        
        containerLayout.addSubview(questionsLabel)
        containerLayout.addSubview(questionDescription)
        
        questionsLabel.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        questionsLabel.topAnchor.constraint(equalTo: learnMoreButton.bottomAnchor, constant: 50).isActive = true
        questionsLabel.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -25).isActive = true
        
        questionDescription.topAnchor.constraint(equalTo: questionsLabel.bottomAnchor, constant: 5).isActive = true
        questionDescription.leadingAnchor.constraint(equalTo: containerLayout.leadingAnchor, constant: 25).isActive = true
        questionDescription.trailingAnchor.constraint(equalTo: containerLayout.trailingAnchor, constant: -25).isActive = true
       
        //ADD TO LAST
        questionDescription.bottomAnchor.constraint(equalTo: containerLayout.bottomAnchor, constant: -25).isActive = true
        
        
    }
    
    //------------------------------------------------------------------
    
    func setupTableView(){
        self.tableView.register(QuestionsCell.self, forCellReuseIdentifier: "questionsCell")
        self.tableView.register(ButtonCell.self, forCellReuseIdentifier: "buttonCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        self.tableView.contentInset = insets
        self.tableView.separatorStyle = .none
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hideTableViewRows {
            return 0
        } else {
            return questionArray.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case questionArray.count:
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonCell
            buttonCell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            if(questionArray.count > MAX_AMOUNT_OF_QUESTIONS){
                buttonCell.button.isHidden = true
            } else {
                buttonCell.button.isHidden = false
            }
            return buttonCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionsCell", for: indexPath) as! QuestionsCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.textField.placeholder = "Question \(indexPath.row + 1)"
            cell.textField.text = questionArray[indexPath.row]
            cell.textField.delegate = self
            cell.removeQuestion.addTapGestureRecognizer{
                self.updateQuestionsValue()
                self.questionArray.remove(at: indexPath.row)
                self.updateTableView()
            }
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case questionArray.count:
            if(questionArray.count <= MAX_AMOUNT_OF_QUESTIONS){
                self.updateQuestionsValue()
                questionArray.append("")
                self.updateTableView()
            }
            
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func updateQuestionsValue(){
        var x = 0
        for _ in questionArray{
            let indexPath = IndexPath(row: x, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! QuestionsCell
            self.questionArray[indexPath.row] = cell.textField.text ?? ""
            x += 1
        }
    }
    
    func updateTableView(){
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    //Text view-----------------------------------
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //300 chars restriction
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return textView.text.count + (text.count - range.length) <= 80
        
    }
    
    //Listeners-----------------------------------------------------------------
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        switch sender {
        case self.navigationItem.rightBarButtonItem:
            if(switchButton.isOn){
                //Check if any of question is used
                self.updateQuestionsValue()
                if(questionArray.contains {$0.count >= 1}){
                    self.showPayController()
                } else {
                    HelperViewTransitions.showLearnMoreViewController(viewCode:3, currentViewController: self)
                }
            } else {
                self.showPayController()
            }
        default:
            break
        }
    }
    
    @objc func switchChanged(sender: UISwitch) {
        
        if sender.isOn {
            questionsLabel.isHidden = false
            questionDescription.isHidden = false
            hideTableViewRows = false
        } else {
            questionsLabel.isHidden = true
            questionDescription.isHidden = true
            hideTableViewRows = true
        }

        self.updateTableView()
        
    }
    
    //Do functions------------------------------------------------------
    
    func showPayController(){
        //do not send array of questions if switch is off
        if switchButton.isOn {
            createServiceModel.questionArray = questionArray.filter{ $0.count > 0}
        }
        
        createServiceModel.variedPricing = switchButton.isOn
        
        let viewController = ServicePayController()
        viewController.createServiceModel = createServiceModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
}

class QuestionsCell:UITableViewCell{
    
    public let textField:UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Question 1"
        textField.textColor = .black
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.cornerRadius = 10
        textField.textAlignment = NSTextAlignment.left
        textField.setLeftRightPaddingPoints(10)
        return textField
    }()
    
    
    public let removeQuestion:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "binIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(textField)
        self.addSubview(removeQuestion)
        
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        textField.trailingAnchor.constraint(equalTo: removeQuestion.leadingAnchor, constant: -15).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        removeQuestion.widthAnchor.constraint(equalToConstant: 20).isActive = true
        removeQuestion.heightAnchor.constraint(equalToConstant: 20).isActive = true
        removeQuestion.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        removeQuestion.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ButtonCell:UITableViewCell {
    
    public let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("Add Question", for: .normal)
        button.backgroundColor = .lightGray
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        
        
        self.addSubview(button)
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
