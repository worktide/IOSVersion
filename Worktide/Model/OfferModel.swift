//
//  OfferModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-10-24.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class OfferModel: NSObject{
   
    var jobID: String?
    var applicantOffer: String?
    
    init(jobID: String?, applicantOffer: String?) {
        self.jobID = jobID
        self.applicantOffer = applicantOffer
    }

}
