//
//  Search.swift
//  StudentHelpApp
//
//  Created by Кирилл on 11.01.19.
//  Copyright © 2019 Кирилл. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

struct Search {
    
    private var _username: String!
    
    private var _userImg: String!
    
    private var _userKey: String!
    
    private var _userRef: DatabaseReference!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var username: String {
        
        return _username
    }
    
    var userImg: String {
        
        return _userImg
    }
    
    var userKey: String{
        
        return _userKey
    }
    
    init(username: String, userImg: String) {
        
        _username = username
        
        _userImg = userImg
    }

    init(userKey: String, messageData: Dictionary<String,AnyObject>) {
        _userKey = userKey
        
        if let username = messageData["name"] as? String {
            _username = username
        }
        
        if let userImg = messageData["userImage"] as? String {
            
            _userImg = userImg
        }
        
        _userRef = Database.database().reference().child("messages").child(_userKey)
    }

}

