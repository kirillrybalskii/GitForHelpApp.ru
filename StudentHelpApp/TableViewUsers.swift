//
//  TableViewUsers.swift
//  StudentHelpApp
//
//  Created by Кирилл on 03.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import UIKit
import Firebase

enum selectedScope:Int {
    case subject = 0
    case user = 1
}
protocol ProfileDelegate {
    func DidCreateNewAssignment(assignment: AssignmentItem)
}

class TableViewUsers: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var TableViewUsers: UITableView!
    //MARK: Properties
    var user : User!
    var assignmentItem: [AssignmentItem] = []
    let ref = Database.database().reference(withPath: "assignmentsItems")
    let usersRef = Database.database().reference(withPath: "online")
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
            self.initialDataAry = Items
            self.tableView.reloadData()
        })
     self.searchBarSetup()
     print("numberOfAssingments: \(assignmentItem.count)")
        
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
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignmentItem.count
    }
    
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! TableViewCellUser
        cell.ProfileImage.layer.borderWidth = 1
        cell.ProfileImage.layer.masksToBounds = false
        cell.ProfileImage.layer.borderColor = UIColor.black.cgColor
        cell.ProfileImage.layer.cornerRadius = cell.ProfileImage.frame.height/2
        cell.ProfileImage.clipsToBounds = true
        
        let assignment = assignmentItem[indexPath.row]
        cell.ProfileImage.image = UIImage(named: "TestImage")
        cell.UserName.text? = assignment.addedByUser
        cell.Subject.text! = assignment.subject
        cell.TaskInfo.text! = assignment.whatToDo
       // cell.Deadline.text! = String(describing: daysBetween(deadline: assignment.deadline))
        cell.Deadline.text! = assignment.deadline
        return cell
    }
    
    func daysBetween(deadline: String) -> Int? {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "MM/dd/yyyy"
        let endDate: Date = dateStringFormatter.date(from: deadline)!
        let currentDate = Date()
        return Calendar.current.dateComponents([Calendar.Component.day], from: currentDate, to: endDate).day!
    }
    
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: Add Item
    @IBAction func AddButtonTouched(_ sender: UIBarButtonItem) {
        let popUpVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUp") as! PopUpAssignmentFormViewController
        self.addChildViewController(popUpVc)
        popUpVc.view.frame = self.view.frame
        self.view.addSubview(popUpVc.view)
        popUpVc.didMove(toParentViewController: self)
        }
    
    // MARK: - search bar delegate
    var initialDataAry: [AssignmentItem] = []
    
    func searchBarSetup() {
        let searchBar = UISearchBar(frame: CGRect(x:0,y:0,width:(UIScreen.main.bounds.width),height:70))
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Subject","User"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.assignmentItem = initialDataAry
            self.tableView.reloadData()
        }else {
            filterTableView(index: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    func filterTableView(index:Int,text:String) {
        switch index {
        case selectedScope.subject.rawValue:
            //fix of not searching when backspacing
            self.assignmentItem = initialDataAry.filter({ (mod) -> Bool in
                return mod.subject.lowercased().contains(text.lowercased())
            })
            self.tableView.reloadData()
        case selectedScope.user.rawValue:
            //fix of not searching when backspacing
            self.assignmentItem = initialDataAry.filter({ (mod) -> Bool in
                return mod.addedByUser.lowercased().contains(text.lowercased())
            })
            self.tableView.reloadData()
        default:
            print("no type")
        }
    }

}



