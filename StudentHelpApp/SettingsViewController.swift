//
//  SettingsViewController.swift
//  StudentHelpApp
//
//  Created by Кирилл on 08.01.19.
//  Copyright © 2019 Кирилл. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBAction func LogoutButtonPressed(_ sender: UIButton) {
        let user = Auth.auth().currentUser!
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
        onlineRef.removeValue { (error, _) in
            if let error = error {
                print("Removing online failed: \(error)")
                return
            }
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
            } catch (let error) {
                print("Auth sign out failed: \(error)")
            }
        }
    }

}



