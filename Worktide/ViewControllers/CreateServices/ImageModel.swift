//
//  ImageModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-08.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit

class ImageModel:NSObject{
    
    var image:UIImage?
    var imageString:String?
    
    init(image:UIImage?, imageString:String?) {
        super.init()
        self.image = image
        self.imageString = imageString
        
    }
}
