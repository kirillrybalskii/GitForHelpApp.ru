//
//  SearchViewController.swift
//  StudentHelpApp
//
//  Created by Кирилл on 24.01.19.
//  Copyright © 2019 Кирилл. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

enum selectedScope:Int {
    case subject = 0
    case user = 1
}

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
        //MARK: Properties
    var user : User!
    var profileUser: UserInfo!
    var assignmentItem: [AssignmentItem] = []
    let ref = Database.database().reference(withPath: "assignments")
    let usersRef = Database.database().reference(withPath: "online")
    var cellData = [TableViewCellUser]()
    var page: Int!
    
    @IBAction func segmentedControllChanged(_ sender: UISegmentedControl) {
        page = sender.selectedSegmentIndex
        self.TableViewUsers.reloadData()
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var TableViewUsers: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarSetup()
        downLoadAssignmets()
        downloadUserProfile()
        upLoadOnlineUsers()
        page = 0
    }
    
   func searchBarSetup() {
//        let searchBar = UISearchBar(frame: CGRect(x:0,y:0,width:(UIScreen.main.bounds.width),height:70))
//        searchBar.showsScopeBar = true
//        
//        searchBar.scopeButtonTitles = ["Subject","User"]
//        searchBar.selectedScopeButtonIndex = 0
//        searchBar.delegate = self
//        self.TableViewUsers.tableHeaderView = searchBar
    self.searchBar.delegate = self
    self.searchBar.barTintColor = UIColor(red: 226.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 0.2)
    self.searchBar.layer.cornerRadius = 20
    self.searchBar.clipsToBounds = true
    if let textfield = self.searchBar.value(forKey: "searchField") as? UITextField {
        textfield.textColor = UIColor.black
        textfield.backgroundColor = UIColor(red: 226.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 0.2)
        }
    }
    
    func downloadUserProfile() {
        let currentUserId = KeychainWrapper.standard.string(forKey: "uid")
        let refUserInfo = Database.database().reference().child("usersInfo")
        refUserInfo.child(currentUserId!).child("userData").observe(.value, with: { (snapshot) in
            
            let userProfile = UserInfo(snapshot: snapshot)
            self.profileUser = userProfile!
            //            self.profileUser.userImage = userProfile!.userImage
            //            self.profileUser.universityName = (userProfile?.universityName)!
            //            self.profileUser.facultyName = (userProfile?.facultyName)!
            //            self.profileUser.name = (userProfile?.name)!
            //            self.profileUser.yearOfStudy = (userProfile?.yearOfStudy)!
            print("current userProfileInfo downloaded")
            
        })
    }
    
    func downLoadAssignmets() {
        
        ref.observe(.value, with: {snapshot in
            var Items : [AssignmentItem] = []
            for child in snapshot.children{
                if let snapshot = child as? DataSnapshot,
                    let userItem = AssignmentItem(snapshot: snapshot) {
                    Items.append(userItem)}
            }
            self.assignmentItem = Items
            self.initialDataAry = Items
            self.TableViewUsers.reloadData()
            print("numberOfAssingments: \(self.assignmentItem.count)")
        })
        
    }
    
    func upLoadOnlineUsers() {
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopUpSegue"{
            let destinationVC = segue.destination as! PopUpAssignmentFormViewController
            destinationVC.user = self.user
            destinationVC.userProfileInfo = self.profileUser
        }
    }
    
    // MARK: tableView delegate
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignmentItem.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell", for: indexPath) as! TableViewCellUser
        cell.ProfileImage.layer.borderWidth = 1
        cell.ProfileImage.layer.masksToBounds = false
        cell.ProfileImage.layer.borderColor = UIColor.black.cgColor
        cell.ProfileImage.layer.cornerRadius = cell.ProfileImage.frame.height/2
        cell.ProfileImage.clipsToBounds = true
        
        let assignment = assignmentItem[indexPath.row]
        cell.configCell(assignmentItem: assignment)
        return cell
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: Add Item
//    @IBAction func AddButtonTouched(_ sender: UIBarButtonItem) {
//        let popUpVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUp") as! PopUpAssignmentFormViewController
//        self.addChildViewController(popUpVc)
//        popUpVc.view.frame = self.view.frame
//        self.view.addSubview(popUpVc.view)
//        popUpVc.didMove(toParentViewController: self)
//    }
    
    // MARK: - search bar delegate
    var initialDataAry: [AssignmentItem] = []
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.assignmentItem = initialDataAry
            self.TableViewUsers.reloadData()
        }else {
            filterTableView(index: self.page, text: searchText)
        }
    }
    
    func filterTableView(index:Int,text:String) {
        switch index {
        case selectedScope.subject.rawValue:
            //fix of not searching when backspacing
            self.assignmentItem = initialDataAry.filter({ (mod) -> Bool in
                return mod.subject.lowercased().contains(text.lowercased())
            })
            self.TableViewUsers.reloadData()
        case selectedScope.user.rawValue:
            //fix of not searching when backspacing
            self.assignmentItem = initialDataAry.filter({ (mod) -> Bool in
                return mod.addedByUser.lowercased().contains(text.lowercased())
            })
            self.TableViewUsers.reloadData()
        default:
            print("no type")
        }
    }
    
}
