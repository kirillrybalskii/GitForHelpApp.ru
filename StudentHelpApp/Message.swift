//
//  Message.swift
//  StudentHelpApp
//
//  Created by Кирилл on 10.01.19.
//  Copyright © 2019 Кирилл. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

struct Message {
    
    private var _message: String!
    
    private var _sender: String!
    
    private var _messageKey: String!
    
    private var _dialogRef: DatabaseReference!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var message: String {
        
        return _message
    }
    
    var sender: String {
        
        return _sender
    }
    
    var messageKey: String{
        
        return _messageKey
    }
    
    init(message: String, sender: String) {
        
        _message = message
        
        _sender = sender
    }
    
    init(messageKey: String, postData: Dictionary<String, AnyObject>) {
        
        _messageKey = messageKey
        
        if let message = postData["message"] as? String {
            
            _message = message
        }
        
        if let sender = postData["sender"] as? String {
            
            _sender = sender
        }
        
        _dialogRef = Database.database().reference().child("dialogs").child(_messageKey)
    }
}

