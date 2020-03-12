//
//  IntExtension.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-16.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit

extension Int{
    
    
    func minutesToWords() -> String{
        
        let hour = self / 60
        let minutes = self % 60
        
        if(hour == 0){
            return String(minutes) + " min"
        } else {
            if(hour == 1){
                return String(hour) + " hour " + String(minutes) + " min"
            } else {
                let day = hour/24
                
                if(day == 1){
                    return("\(day) day")
                } else if (day > 1) {
                    return("\(day) days")
                }
                
                return String(hour) + " hours " + String(minutes) + " min"
            }
        }
        
    }
    
    func daysToWords() -> String{
        
        if(self == 1){
            return("\(self) day")
        } else {
            return("\(self) days")
        }
    }
}
