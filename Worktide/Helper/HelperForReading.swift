//
//  Helper.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-02-19.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class HelperForReading {
    
    static func changeDurationToWords(fromDate:Date?, toDate:Date?) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour]
        formatter.unitsStyle = .full
        return formatter.string(from: fromDate!, to: toDate!)!
    }
    
    static func addBoldText(fullString: NSString, boldPartsOfString: [String], font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedString.Key.font:font!]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
    
}
