//
//  UserInfo.swift
//  StudentHelpApp
//
//  Created by Кирилл on 30.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct UserInfo  {
    
    let ref: DatabaseReference?
    let key: String
    var name: String
    var universityName: String
    var facultyName: String
    var yearOfStudy: String
    
    init(name: String, universityName:String, facultyName: String, yearOfStudy: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.name = name
        self.universityName = universityName
        self.facultyName = facultyName
        self.yearOfStudy = yearOfStudy
    }
    init?(snapshot: DataSnapshot) {
        guard
        let value = snapshot.value as? [String: AnyObject],
        let name = value["name"] as? String,
        let universityName = value["university"] as? String,
        let facultyName = value["facultyName"] as? String,
        let yearOfStudy = value["yearOfStudy"] as? String
            else {return nil}
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.universityName = universityName
        self.facultyName = facultyName
        self.yearOfStudy = yearOfStudy
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "university": universityName,
            "facultyName": facultyName,
            "year": yearOfStudy
        ]
    }

    
}
