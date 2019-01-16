//
//  SearchToSendViewController.swift
//  StudentHelpApp
//
//  Created by Кирилл on 11.01.19.
//  Copyright © 2019 Кирилл. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SearchToSendViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func goBack(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }

    
    // Properties
    var searchDetail = [Search]()
    var filteredData = [Search]()
    var isSearching = false
    var detail: Search!
    var recipient: String!
    var dialogId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        Database.database().reference().child("users").observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                self.searchDetail.removeAll()
                
                for data in snapshot {
                    
                    if let postDict = data.value as? Dictionary<String, AnyObject> {
                        
                        let key = data.key
                        
                        let post = Search(userKey: key, messageData: postDict)
                        
                        self.searchDetail.append(post)
                        self.filteredData.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destionViewController = segue.destination as? MessageViewController {
            
            destionViewController.recipient = recipient
            
            destionViewController.dialogId = dialogId
        }
    }
}
extension SearchToSendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearching {
            
            return filteredData.count
            
        }else {
            
            return searchDetail.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? SearchTableViewCell {
            
            let filteredDt = filteredData[indexPath.row]
            cell.configCell(searchDetail: filteredDt)
            
            return cell
            
        } else {
            
            return SearchTableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSearching {
            
            self.recipient = filteredData[indexPath.row].userKey
            
        } else {
            
            self.recipient = searchDetail[indexPath.row].userKey
        }
        
        self.performSegue(withIdentifier: "toMessage", sender: nil)
    }
    }


extension SearchToSendViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            isSearching = false
            
            view.endEditing(true)
            
            tableView.reloadData()
            
        } else {
            
            isSearching = true
            
            filteredData = searchDetail.filter({ $0.username == searchBar.text! })
            
            tableView.reloadData()
        }
    }

}
