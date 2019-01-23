//
//  ChatMessageTableViewCell.swift
//  StudentHelpApp
//
//  Created by Кирилл on 10.01.19.
//  Copyright © 2019 Кирилл. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ChatMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var recievedMessageLbl: UILabel!
    
    @IBOutlet weak var recievedMessageView: UIView!
    
    @IBOutlet weak var sentMessageLbl: UILabel!
    
    @IBOutlet weak var sentMessageView: UIView!

    var message: Message!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    func configCell(message: Message) { 
        self.message = message
        
        if message.sender == currentUser {
            
            sentMessageView.isHidden = false
            sentMessageLbl.text = message.message
            
            //recievedMessageLbl.text = ""
            
            recievedMessageView.isHidden = true
            
        } else {
            
            sentMessageView.isHidden = true
            
           // sentMessageLbl.text = ""
            
            recievedMessageLbl.text = message.message
            
            recievedMessageLbl.isHidden = false
        }
    }

}
extension UIView {
    func changeToCircle() {
       self.layer.cornerRadius = self.frame.size.width/2
       self.clipsToBounds = true
       self.layer.borderColor = UIColor.white.cgColor
       self.layer.borderWidth = 5.0
    }
}

