//
//  MessagesModel.swift
//  Worktide
//
//  Created by Kristofer Huang on 2019-09-05.
//  Copyright © 2019 Kristofer Huang. All rights reserved.
//

import UIKit
import FirebaseAuth

class MessagesModel: NSObject {

    var senderID:String?
    var receiverID:String?
    var messageText:String?
    
    init(dictionary: [String: Any]) {
        self.senderID = dictionary["senderID"] as? String
        self.messageText = dictionary["messageText"] as? String
        self.receiverID = dictionary["receiverID"] as? String
    }
    
    func chatPartnerId() -> String? {
        return senderID == Auth.auth().currentUser?.uid ? receiverID : senderID
    }
    
}
