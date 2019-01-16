//
//  MessageViewController.swift
//  StudentHelpApp
//
//  Created by Кирилл on 10.01.19.
//  Copyright © 2019 Кирилл. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class MessageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipientLabel: UILabel!
    
    //Properties
    var dialogId: String!
    var messages = [Message]()
    var message: Message!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")    
    var recipient: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300

        getRecipientName()
        
        if dialogId != "" && dialogId != nil {
            
            loadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(800)) {
            
            self.moveToBottom()
        }
    }
    
    func getRecipientName() {
        
        let recipientData = Database.database().reference().child("users").child(recipient)
        recipientData.observeSingleEvent(of: .value, with: { (snapshot) in

            let data = snapshot.value as! Dictionary<String, AnyObject>
            let username = data["name"]
            //let userImg = data["userImage"]
            self.recipientLabel.text! = username as! String
        })
    }
    @IBAction func sendPressed(_ sender: UIButton) {
       
        dismissKeyboard()
        
 if (messageField.text != nil && messageField.text != "") {
     
     if dialogId == nil {
         
       let post: Dictionary<String, AnyObject> = [
          "message": messageField.text! as AnyObject,
          "sender": currentUser! as AnyObject
      ]
        
         let message: Dictionary<String, AnyObject> = [
             "lastmessage": messageField.text! as AnyObject,
             "recipient": recipient as AnyObject
         ]
         
         let recipientMessage: Dictionary<String, AnyObject> = [
             "lastmessage": messageField.text! as AnyObject,
             "recipient": currentUser! as AnyObject
         ]
         
         dialogId = Database.database().reference().child("dialogs").childByAutoId().key
         
         let firebaseMessage = Database.database().reference().child("dialogs").child(dialogId).childByAutoId()
         
        firebaseMessage.setValue(post)
         
         let recipentMessage = Database.database().reference().child("usersInfo").child(recipient!).child("dialogs").child(dialogId)
         
         recipentMessage.setValue(recipientMessage)
         
         let userMessage = Database.database().reference().child("usersInfo").child(currentUser!).child("dialogs").child(dialogId)
         
         userMessage.setValue(message)
         
         loadData()
     } else if dialogId != "" {
         
         let post: Dictionary<String, AnyObject> = [
             "message": messageField.text! as AnyObject,
             "sender": currentUser! as AnyObject
         ]
         
         let message: Dictionary<String, AnyObject> = [
             "lastmessage": messageField.text! as AnyObject,
             "recipient": recipient as AnyObject
         ]
         
         let recipientMessage: Dictionary<String, AnyObject> = [
             "lastmessage": messageField.text! as AnyObject,
             "recipient": currentUser! as AnyObject
         ]
         
         let firebaseMessage = Database.database().reference().child("dialogs").child(dialogId).childByAutoId()
         
         firebaseMessage.setValue(post)
         
         let recipentMessage = Database.database().reference().child("usersInfo").child(recipient).child("dialogs").child(dialogId)
         
         recipentMessage.setValue(recipientMessage)
         
         let userMessage = Database.database().reference().child("usersInfo").child(currentUser!).child("dialogs").child(dialogId)
         
         userMessage.setValue(message)
         
         loadData()
     }
     
     messageField.text = ""
 }
 
        moveToBottom()
    }

    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    //MARK: Common functions
    func loadData() {
        Database.database().reference().child("dialogs").child(dialogId).observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                self.messages.removeAll()
                
                for data in snapshot {
                    
                    if let postDict = data.value as? Dictionary<String, AnyObject> {
                        
                        let key = data.key
                        
                        let post = Message(messageKey: key, postData: postDict)
                        
                        self.messages.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })

    }
    // moves view higher when keyboard appears
    func keyboardWillShow(notify: NSNotification) {
        
        if let keyboardSize = (notify.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 0 {
                
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notify: NSNotification) {
        
        if let keyboardSize = (notify.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y != 0 {
                
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    // scrolls tableView to the last message
    func moveToBottom() {
        
        if messages.count > 0  {
            
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Message") as? ChatMessageTableViewCell {
            
            cell.configCell(message: message)
            
            return cell
            
        } else {
            
            return ChatMessageTableViewCell()
        }
    }

}
