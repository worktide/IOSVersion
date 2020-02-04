//
//  JobsDetailedModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-10-10.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit

class JobsDetailedModel:NSObject{
   
    var jobTitle: String?
    var jobDescription: String?
    var jobRequirements = [String]()
    var jobExperience: Float = 0
    var jobPay:String?
    var jobDate:String?
    var latitude:Double = 0
    var longitude:Double = 0
    var jobCreatedDate:Double = 0
    var jobID:String?
    var creatorID:String?
    var applicantsID = [String]()
    var applicantChosen: String?
    var isCompleted:Bool
    var applicantRated: Bool?
    var creatorRated: Bool?
    
    init(creatorID:String?,jobTitle: String?, jobDescription: String?, jobExperience:Float, jobRequirements:[String], jobPay:String?, jobDate:String?, latitude:Double, longitude: Double, jobCreatedDate:Double, jobID:String?, applicantsID: [String], applicantChosen:String?, isCompleted:Bool, applicantRated: Bool?, creatorRated:Bool?) {
        self.creatorID = creatorID
        self.jobTitle = jobTitle
        self.jobDescription = jobDescription
        self.jobRequirements = jobRequirements
        self.jobExperience = jobExperience
        self.jobPay = jobPay
        self.jobDate = jobDate
        self.latitude = latitude
        self.longitude = longitude
        self.jobCreatedDate = jobCreatedDate
        self.jobID = jobID
        self.applicantsID = applicantsID
        self.applicantChosen = applicantChosen
        self.isCompleted = isCompleted
        self.applicantRated = applicantRated
        self.creatorRated = creatorRated
    }

}
