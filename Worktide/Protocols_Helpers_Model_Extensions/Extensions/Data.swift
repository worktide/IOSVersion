//
//  Data.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-09-21.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import Foundation

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
