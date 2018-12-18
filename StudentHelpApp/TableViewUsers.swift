//
//  TableViewUsers.swift
//  StudentHelpApp
//
//  Created by Кирилл on 03.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import UIKit
import Firebase

class TableViewUsers: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TableViewUsers: UITableView!
    //MARK: Properties
    var user : User!
    var assignmentItem = [AssignmentItem]()
    let ref = Database.database().reference(withPath: "assignmentsItems")
    var cellData = [TableViewCellUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.observe(.value, with: {snapshot in
            var Items : [AssignmentItem] = []
            for child in snapshot.children{
                if let snapshot = child as? DataSnapshot,
                    let userItem = AssignmentItem(snapshot: snapshot) {
                    Items.append(userItem)}
            }
            self.assignmentItem = Items
            self.TableViewUsers.reloadData()
            self.TableViewUsers.delegate = self
            self.TableViewUsers.dataSource = self
        })
        
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignmentItem.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! TableViewCellUser
        cell.ProfileImage.layer.borderWidth = 1
        cell.ProfileImage.layer.masksToBounds = false
        cell.ProfileImage.layer.borderColor = UIColor.black.cgColor
        cell.ProfileImage.layer.cornerRadius = cell.ProfileImage.frame.height/2
        cell.ProfileImage.clipsToBounds = true
        
        let assignment = assignmentItem[indexPath.row]
        cell.textLabel?.text = assignment.whatToDo
        cell.detailTextLabel?.text = assignment.addedByUser
        cell.detailTextLabel?.text = String(describing: daysBetween(deadline: assignment.deadline))
        
        return cell
    }
    func daysBetween(deadline: String) -> Int? {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        let endDate: Date = dateStringFormatter.date(from: deadline)!
        let currentDate = Date()
        return Calendar.current.dateComponents([Calendar.Component.day], from: currentDate, to: endDate).day!
    }
    
    public static func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: Add Item
    @IBAction func AddButtonTouched(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New assignment", message: "Add essential info", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default){ _ in
            
            
            let whatToDo = alert.textFields![0]
            let subject = alert.textFields![1]
            let deadline = alert.textFields![2]
            
            let assignment = AssignmentItem(whatToDo: whatToDo.text!, subject: subject.text!, deadline: deadline.text!, addedByUser: "", completed: false)
            let assignmentItemRef = self.ref.child(whatToDo.text!)
            
            assignmentItemRef.setValue(assignment.toAnyObject())
            
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField{ whatToDo in
            whatToDo.placeholder = "Enter what to do?"}
        alert.addTextField{ Subject in
            Subject.placeholder = "Enter subject"}
        alert.addTextField{ Deadline in
            Deadline.placeholder = "Enter deadline"}
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}
