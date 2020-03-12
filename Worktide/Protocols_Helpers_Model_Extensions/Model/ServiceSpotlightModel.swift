//
//  ServiceSpotlightModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-24.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit

class ServiceSpotlightModel:NSObject{
   
    var creatorID: String?
    var creatorPhoto: UIImage?
    var creatorName:String?
    var documentID:String?
    var set:Int?
    
    init(creatorID:String?, creatorPhoto:UIImage?, creatorName:String?, documentID:String?, set:Int?) {
        self.creatorID = creatorID
        self.creatorPhoto = creatorPhoto
        self.creatorName = creatorName
        self.documentID = documentID
        self.set = set
    }

}
