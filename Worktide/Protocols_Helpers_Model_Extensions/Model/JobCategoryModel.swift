//
//  JobCategoryModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-03.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation

class JobCategoryModel:NSObject{
   
    var jobTitle: String?
    var jobDescription: String?
    var iconImagePath: String?
    
    init(jobTitle: String?, jobDescription: String?, iconImagePath:String?) {
        self.jobTitle = jobTitle
        self.jobDescription = jobDescription
        self.iconImagePath = iconImagePath
    }

}
