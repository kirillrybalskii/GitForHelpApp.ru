//
//  ProfileViewController.swift
//  StudentHelpApp
//
//  Created by Кирилл on 30.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UniversityName: UILabel!
    @IBOutlet weak var FacultyName: UILabel!
    @IBOutlet weak var YearOfStudy: UILabel!
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        page = sender.selectedSegmentIndex
        tableViewToDoList.reloadData()
    }
    
    @IBOutlet weak var tableViewToDoList: UITableView!
    var assignmentItem: [AssignmentItem] = []
    
    weak var PopUpAssignmentCreationReference: PopUpAssignmentFormViewController?
    
    var page: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "customCell", bundle: nil)
        tableViewToDoList.register(nib, forCellReuseIdentifier: "customCell")
        page = 0
        createUserProfile()
        PopUpAssignmentCreationReference?.delegate = self
        populateWithUserAssignments()
    }
    
    func populateWithUserAssignments(){
        if self.assignmentItem.count == 0{
            JsonWork.JsonReadAssignments()
            self.assignmentItem = JsonWork.assignmentsFromJson
        }
    }
    
    func createUserProfile(){
//        UserName.text! = LocalUser.Name
//        UniversityName.text! = LocalUser.UniversityName
//        FacultyName.text! = LocalUser.FacultyName
//        YearOfStudy.text! = LocalUser.YearOfStudy
        
        JsonWork.JsonRead()
         UserName.text! = (JsonWork.userData?.name)!
        UniversityName.text! = (JsonWork.userData?.universityName)!
        FacultyName.text! = (JsonWork.userData?.facultyName)!
        YearOfStudy.text! = (JsonWork.userData?.yearOfStudy)!
    }
}

extension ProfileViewController: UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if page == 1 {
            return assignmentItem.count }
        else { return 1 }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if page == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        let assignment = assignmentItem[indexPath.row]
        cell.whatToDo.text! = assignment.whatToDo
        cell.subject.text! = assignment.subject
        cell.deadline.text! = assignment.deadline
        return cell
        //    return cell }
        //else { return }
        
    }
}


extension ProfileViewController: ProfileDelegate {
    func DidCreateNewAssignment(assignment: AssignmentItem) {
        assignmentItem.append(assignment)
    }
}
