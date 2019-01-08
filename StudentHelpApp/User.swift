//
//  User.swift
//  StudentHelpApp
//
//  Created by Кирилл on 06.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import Foundation
import Firebase

class User: NSObject, NSCoding
{
    let uid: String
    let email: String

    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
    public convenience required init?(coder aDecoder: NSCoder) {
        
        let userId = aDecoder.decodeObject(forKey: "userId") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        
        self.init(uid: userId, email: email)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "userId")
        aCoder.encode(email, forKey: "email")
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }

}
