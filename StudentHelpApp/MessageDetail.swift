//
//  MessageDetail.swift
//  StudentHelpApp
//
//  Created by Кирилл on 09.01.19.
//  Copyright © 2019 Кирилл. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

class MessageDetail {
    
    private var _recipient: String!
    
    private var _lastMessage: String!
    
    private var _messageKey: String!
    
    private var _messageRef: DatabaseReference!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var recipient: String {
        
        return _recipient
    }
    
    var lastMessage: String {
        return _lastMessage
    }
    
    var messageKey: String {
        
        return _messageKey
    }
    
    var messageRef: DatabaseReference {
        
        return _messageRef
    }
    
    init(recipient: String) {
        
        _recipient = recipient
    }
    
    init(messageKey: String, messageData: Dictionary<String, AnyObject>) {
        
        _messageKey = messageKey
        
        if let recipient = messageData["recipient"] as? String {
            
            _recipient = recipient
        }
        
        if let lastMess = messageData["lastmessage"] as? String {
            _lastMessage = lastMess
        }
        
        _messageRef = Database.database().reference().child("recipient").child(_messageKey)
    }

}
