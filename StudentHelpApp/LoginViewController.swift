//
//  ViewController.swift
//  StudentHelpApp
//
//  Created by Кирилл on 02.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordButton: UIButton!
    
    @IBOutlet weak var LoginTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            let attributedString = NSAttributedString(string: "Forgot your password?", attributes: [NSForegroundColorAttributeName: UIColor.white, NSUnderlineStyleAttributeName:1])
            self.passwordButton.setAttributedTitle(attributedString, for: .normal)}
        //new user signed in
        DispatchQueue.global(qos: .userInitiated).async {Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "LoginToHome", sender: nil)
                self.LoginTextField.text = nil
                self.PasswordTextField.text = nil
            }
            }
        }

        //let ref = DataBase.database().reference()
       // ref.child("UserId/UserName").setValue("Mike")
       // ref.childByAutoId().setValue(["UserName":"Mike", "Faculty": 2])
    }

        @IBAction func LoginButtonPressed(_ sender: UIButton)
        {
        guard let email = LoginTextField.text,
            let password = PasswordTextField.text
            else
        {
            return
            }
            Auth.auth().signIn(withEmail: email, password: password)
            { (user, error) in
                if let error = error, user == nil {
                    let alert = UIAlertController(title: "Login in failed", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
    }
    
    @IBAction func RegisterButtonPressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default)
        { _ in
            
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
           // let facultyNameField = alert.textFields![2]
            //let yearOfStudyField = alert.textFields![3]
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!)
            { (user, error) in
                if error == nil
                {
                    Auth.auth().signIn(withEmail: self.LoginTextField.text!,
                                       password: self.PasswordTextField.text!)
                }
            }
            //serializing
            let createdUser = User(uid: passwordField.text!, email: emailField.text!)
            let filePath = try! FileSave.buildPath(path: "Userdata", inDirectory: FileManager.SearchPathDirectory.cachesDirectory, subdirectory: "archive")
            NSKeyedArchiver.archiveRootObject(createdUser, toFile: filePath)

        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your faculty name"
        }
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your year of study"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
   
}
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == LoginTextField {
            PasswordTextField.becomeFirstResponder()
        }
        if textField == PasswordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}




