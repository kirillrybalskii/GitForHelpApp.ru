//
//  User.swift
//  StudentHelpApp
//
//  Created by Кирилл on 06.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import Foundation
import Firebase

struct User
{
    let uid: String
    let email: String
    
    var userId: String {
        return uid
    }

    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }

}
