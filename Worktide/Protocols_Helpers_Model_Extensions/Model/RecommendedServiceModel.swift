//
//  RecommendedServiceModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-22.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit

class RecommendedServiceModel: NSObject {
    
    var serviceRating:CGFloat?
    var serviceTitle:String?
    
    init(serviceTitle:String?, serviceRating:String) {
        self.serviceTitle = serviceTitle
        
        if let n = NumberFormatter().number(from: serviceRating) {
            self.serviceRating  = CGFloat(truncating: n)
        }
    }
}
