//
//  JsonWork.swift
//  StudentHelpApp
//
//  Created by Кирилл on 31.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import Foundation
class JsonWork {

    static var userData: UserInfo?
    static var assignmentsFromJson: [AssignmentItem] = []
    
    
   public static func JsonWrite(userinfo : UserInfo) {
    guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let fileUrl = documentDirectoryUrl.appendingPathComponent("Profile.json")
    let info = userinfo.toAnyObject()
    if JSONSerialization.isValidJSONObject(info) {
        do {
            let data = try JSONSerialization.data(withJSONObject: info, options: [])
            try data.write(to: fileUrl, options: [])
            print("data serialized \(data) for url \(fileUrl)")
        } catch {
            print(error)
        }
    }
    }
    
    public static func JsonRead(){
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("Profile.json")
        do {
            let data = try? Data(contentsOf: fileUrl, options: [])
            let json = try JSONSerialization.jsonObject(with: data!, options: [])
        guard let dictionary = json as? [String: String],
            let name = dictionary["name"],
            let universityName = dictionary["university"],
            let facultyName = dictionary["facultyName"],
            let yearOfStudy = dictionary["year"],
            let userImage = dictionary["userImage"]
            else {return}
            
            let user = UserInfo(name: name, universityName:universityName, facultyName: facultyName, yearOfStudy: yearOfStudy, userImage: userImage)
        self.userData = user
        print("deserialized data \(user)")
        } catch {
            print(error)
        }
        
    }
    
    public static func JsonWriteAssignments(assignment: AssignmentItem) {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("Assignments.json")
        let assignmentJson = assignment.toAnyObject()
        if JSONSerialization.isValidJSONObject(assignmentJson) {
            do {
                let data = try JSONSerialization.data(withJSONObject: assignmentJson, options: [])
                try data.write(to: fileUrl, options: [])
                print("data serialized \(assignmentJson) for url \(fileUrl)")
            } catch {
                print(error)
            }
        }
    }
    
    public static func JsonReadAssignments() {
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("Assignments.json")
        do {
            let data = try? Data(contentsOf: fileUrl, options: [])
            guard data != nil
                else {return}
            let json = try JSONSerialization.jsonObject(with: data!, options: [])
            
            guard let dictionary = json as? [String: String],
                let whatToDo = dictionary["whatToDo"],
                let subject = dictionary["subject"],
                let deadline = dictionary["deadline"],
                let addedByUser = dictionary["addedByUser"],
                let completed = dictionary["completed"]
                else {return}
            let newAssignment = AssignmentItem(whatToDo: whatToDo, subject: subject, addedByUser: addedByUser, userImage: LocalUser.userImage!, deadline: deadline, completed: completed.stringToBool())
            self.assignmentsFromJson.append(newAssignment)
                    print("assignments\(dictionary as AnyObject)")
        } catch {print(error)
        }
}
}
extension String {
    func stringToBool()->Bool{
        if self == "true"{
            return true
        } else {return false}
    }
}
