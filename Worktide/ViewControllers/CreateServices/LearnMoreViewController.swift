//
//  LearnMoreViewController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-28.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit

class LearnMoreViewController: UIViewController {
    
    var VIEW_CODE = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        switch VIEW_CODE {
        case 0:
            variedPricingView()
        case 1:
            questionsForCustomerView()
        case 2:
            showRequirementsView()
        case 3:
            showCreateScheduleExamples()
        case 4:
            showAutoSchedulerView()
        default:
            break
        }
    }
    
    func variedPricingView(){
        
    }
    
    func questionsForCustomerView(){
        
    }
    
    func showRequirementsView(){
        
    }
    
    func showCreateScheduleExamples(){
        //make sure to say that this service can only be booked with your availability schedule u set
    }
    
    func showAutoSchedulerView(){
        
    }
}
