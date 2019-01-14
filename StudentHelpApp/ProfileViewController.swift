//
//  ProfileViewController.swift
//  StudentHelpApp
//
//  Created by Кирилл on 30.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UniversityName: UILabel!
    @IBOutlet weak var FacultyName: UILabel!
    @IBOutlet weak var YearOfStudy: UILabel!
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        page = sender.selectedSegmentIndex
        tableViewToDoList.reloadData()
    }
    // MARK: Properties
    @IBOutlet weak var tableViewToDoList: UITableView!
    var assignmentItems: [AssignmentItem] = []
    weak var PopUpAssignmentCreationReference: PopUpAssignmentFormViewController?
    var imagePicker: UIImagePickerController!
    let currentUserId = KeychainWrapper.standard.string(forKey: "uid")
    
    var page: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableViewToDoList.register(nib, forCellReuseIdentifier: "customCell")
        page = 0
        createUserProfile()
        PopUpAssignmentCreationReference?.delegate = self
        populateWithUserAssignments()
    }
    
//    func instantiateImagePicker() {
//        imagePicker = UIImagePickerController()
//        imagePicker.allowsEditing = true
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.delegate = self
//    }
    
    func populateWithUserAssignments(){
        if self.assignmentItems.count == 0{
           let refUserAssignments = Database.database().reference(withPath:"usersInfo").child(self.currentUserId!).child("assignments")
                refUserAssignments.observe(.value, with: { snapshot in
                    // 2
                    var newItems: [AssignmentItem] = []
                    
                    // 3
                    for child in snapshot.children {
                        // 4
                        if let snapshot = child as? DataSnapshot,
                            let assignmentItem = AssignmentItem(snapshot: snapshot) {
                            newItems.append(assignmentItem)
                        }
                    }
                    
                    // 5
                    self.assignmentItems = newItems
                    self.tableViewToDoList.reloadData()
                })
                    }
    }
    
    func createUserProfile(){
        // with static properties
//        UserName.text! = LocalUser.Name
//        UniversityName.text! = LocalUser.UniversityName
//        FacultyName.text! = LocalUser.FacultyName
//        YearOfStudy.text! = LocalUser.YearOfStudy
        // with Json
//        JsonWork.JsonRead()
//         UserName.text! = (JsonWork.userData?.name)!
//        UniversityName.text! = (JsonWork.userData?.universityName)!
//        FacultyName.text! = (JsonWork.userData?.facultyName)!
//        YearOfStudy.text! = (JsonWork.userData?.yearOfStudy)!
        //with Firebase
               let refUserInfo = Database.database().reference(withPath: "usersInfo")
        refUserInfo.child(self.currentUserId!).observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.value as? DataSnapshot, let userProfile = UserInfo(snapshot: snapshot){
                self.UserName.text! = userProfile.name
                self.UniversityName.text! = userProfile.universityName
                self.FacultyName.text! = userProfile.facultyName
                self.YearOfStudy.text! = userProfile.yearOfStudy
            }
        })
    }
}

extension ProfileViewController: UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if page == 1 {
            return assignmentItems.count }
        else { return 1 }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if page == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        let assignment = assignmentItems[indexPath.row]
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
        assignmentItems.append(assignment)
    }
}


