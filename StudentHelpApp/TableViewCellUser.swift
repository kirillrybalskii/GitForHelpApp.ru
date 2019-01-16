//
//  TableViewCellUser.swift
//  StudentHelpApp
//
//  Created by Кирилл on 03.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import UIKit
import FirebaseStorage

class TableViewCellUser: UITableViewCell {

    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var Subject: UILabel!
    @IBOutlet weak var TaskInfo: UILabel!
    @IBOutlet weak var Deadline: UILabel!
    
    var assignment: AssignmentItem!
    
    func configCell(assignmentItem: AssignmentItem) {
        
        self.assignment = assignmentItem
        
        UserName.text! = assignmentItem.addedByUser
        Subject.text! = assignmentItem.subject
        TaskInfo.text! = assignmentItem.whatToDo
        //Deadline.text! = String(describing: self.daysBetween(deadline: assignmentItem.deadline))
        Deadline.text! = assignmentItem.deadline
        
        let ref = Storage.storage().reference(forURL: assignmentItem.userImage)
        ref.getData(maxSize: 1000000, completion: { (data, error) in
            
            if error != nil {
                
                print(" we couldnt upload the img")
                
            } else {
                
                if let imgData = data {
                    
                    if let img = UIImage(data: imgData) {
                        
                        self.ProfileImage?.image = img
                    }
                }
            }
            
        })
    }
    
    func daysBetween(deadline: String) -> Int? {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "MM/dd/yyyy"
        let endDate: Date = dateStringFormatter.date(from: deadline)!
        let currentDate = Date()
        return Calendar.current.dateComponents([Calendar.Component.day], from: currentDate, to: endDate).day!
    }

}
