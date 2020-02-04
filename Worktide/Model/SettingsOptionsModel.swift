//
//  SettingsOptionsModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-11-03.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation

class SettingsOptionModel:NSObject{
   
    var optionsTitle: String?
    var optionsImage: String?
    
    init(optionsTitle:String?, optionsImage:String?) {
        self.optionsTitle = optionsTitle
        self.optionsImage = optionsImage
    }

}
