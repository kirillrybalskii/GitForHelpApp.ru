//
//  AssignmentItem.swift
//  StudentHelpApp
//
//  Created by Кирилл on 06.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct AssignmentItem {
    
    let ref: DatabaseReference?
    let key: String
    let whatToDo : String
    let subject: String
    let addedByUser: String
    let userImage: String
    let deadline : String
    var completed: Bool
    
    init(whatToDo: String, subject: String, addedByUser: String, userImage: String, deadline: String, completed: Bool, key: String = "") {
        self.ref = nil
        self.key = key
        self.whatToDo = whatToDo
        self.subject = subject
        self.addedByUser = addedByUser
        self.userImage = userImage
        self.deadline = deadline
        self.completed = completed
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let whatToDo = value["whatToDo"] as? String,
            let subject = value["subject"] as? String,
            let deadline = value["deadline"] as? String,
            let addedByUser = value["addedByUser"] as? String,
            let userImage = value["userImage"] as? String,
            let completed = value["completed"] as? Bool
                                    
        else {return nil}
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.whatToDo = whatToDo
        self.subject = subject
        self.addedByUser = addedByUser
        self.userImage = userImage
        self.deadline = deadline
        self.completed = completed
    }
    
    func toAnyObject() -> Any {
        return [
            "whatToDo": whatToDo,
            "subject": subject,
            "deadline": deadline,
            "addedByUser": addedByUser,
            "userImage": userImage,
            "completed": completed
        ]
    }
}
