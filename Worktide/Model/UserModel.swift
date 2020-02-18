//
//  UserModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-09-02.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    
    var applicantID: String?
    var applicantName: String?
    var imagePath:String?
    var userRating:CGFloat?
    var applicantOffer:String?
    //var jobID: String?
    
    init(applicantID: String?, applicantName: String?, imagePath:String?, userRating: CGFloat?, applicantOffer:String?) {
        self.applicantID = applicantID
        self.applicantName = applicantName
        self.imagePath = imagePath
        self.userRating = userRating
        self.applicantOffer = applicantOffer
    }

}
