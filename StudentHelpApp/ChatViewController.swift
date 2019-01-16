//
//  ChatViewController.swift
//  StudentHelpApp
//
//  Created by Кирилл on 09.01.19.
//  Copyright © 2019 Кирилл. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var messageDetail = [MessageDetail]()
    var detail: MessageDetail!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    var recipient: String!
    var dialogId: String!

    override func viewDidLoad() {
        super.viewDidLoad()

       tableView.delegate = self
       tableView.dataSource = self
        
        Database.database().reference().child("usersInfo").child(currentUser!).child("dialogs").observe(.value, with: { (snapshot) in
           
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.messageDetail.removeAll()
                
                for data in snapshot {
                    if let messageInfo = data.value as? Dictionary<String, AnyObject> {
                        let key = data.key
                        let messageCellInfo = MessageDetail(messageKey: key, messageData: messageInfo)
                        self.messageDetail.append(messageCellInfo)
                    }
                }
            }
            self.tableView.reloadData()
        })
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageDetail.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageDet = messageDetail[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? MessageTableViewCell, self.messageDetail.count != 0 {
            
            cell.configureCell(messageDetail: messageDet)
            
            return cell
        } else {
            
            return MessageTableViewCell()
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        recipient = messageDetail[indexPath.row].recipient
        
        dialogId = messageDetail[indexPath.row].messageRef.key
        
        performSegue(withIdentifier: "toMessages", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? MessageViewController {
            
            destinationViewController.recipient = recipient
            
            destinationViewController.dialogId = dialogId
        }
    }

}
