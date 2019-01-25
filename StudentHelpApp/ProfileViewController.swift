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
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var ProfileImage: UIImageView!
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
        hideBottomLineOfNavigationItem()
        createUserProfile()
        populateWithUserAssignments()
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableViewToDoList.register(nib, forCellReuseIdentifier: "customCell")
        tableViewToDoList.backgroundColor = UIColor.white
        page = 0
    }
    

    func hideBottomLineOfNavigationItem() {
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationBar?.shadowImage = UIImage()
    }
    func populateWithUserAssignments(){
        
        let refUserAssignments = Database.database().reference(withPath:"usersInfo").child(self.currentUserId!).child("assignments")
                refUserAssignments.observe(.value, with: { snapshot in
                    var newItems: [AssignmentItem] = []
                    for child in snapshot.children {
                        if let snapshot = child as? DataSnapshot,
                            let assignmentItem = AssignmentItem(snapshot: snapshot) {
                            newItems.append(assignmentItem)
                        }
                    }
                    self.assignmentItems = newItems
                    self.tableViewToDoList.reloadData()
                })
        
    }
    
    func downloadUserImageUrl(userImage: String) {
        
        let ref = Storage.storage().reference(forURL: userImage)
        
        ref.getData(maxSize: 1000000, completion: { (data, error) in
            
            if error != nil {
                
                print(" we couldnt upload the img")
                
            } else {
                
                if let imgData = data {
                    
                    if let img = UIImage(data: imgData) {
                        self.ProfileImage.image = img
                       self.ProfileImage.layer.borderWidth = 1
                       self.ProfileImage.layer.masksToBounds = false
                       self.ProfileImage.layer.borderColor = UIColor.black.cgColor
                       self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.height/2
                       self.ProfileImage.clipsToBounds = true

                    }
                }
            }
            
        })
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
               let refUserInfo = Database.database().reference().child("usersInfo")
        refUserInfo.child(self.currentUserId!).child("userData").observe(.value, with: { (snapshot) in
            
                let userProfile = UserInfo(snapshot: snapshot)
                self.UserName.text = userProfile?.name
                self.UniversityName.text = userProfile?.universityName
                self.FacultyName.text = userProfile?.facultyName
                self.YearOfStudy.text = userProfile?.yearOfStudy
                self.downloadUserImageUrl(userImage: (userProfile?.userImage)!)
        })
    }
}

extension ProfileViewController: UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if page == 1 {
            return assignmentItems.count
        }
        else { return 1 }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if page == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        guard assignmentItems.count != 0
            else {return UITableViewCell()}
        let assignment = assignmentItems[indexPath.row]
        cell.customInit(WhatToDo: assignment.whatToDo, Subject: assignment.subject, Deadline: assignment.deadline)
        return cell
        } else {
            return UITableViewCell()
        }
        
    }

}


