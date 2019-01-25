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
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordButton: UIButton!
    
    @IBOutlet weak var LoginTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        //PRESENT ALERT
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    var newUser: User!
    
    weak var RegisterNewUserReference : RegisterViewController?
   
    override func viewDidLoad() {
        super.viewDidLoad()
            let attributedString = NSAttributedString(string: "Forgot your password?", attributes: [NSForegroundColorAttributeName: UIColor.white, NSUnderlineStyleAttributeName:1])
        self.passwordButton.setAttributedTitle(attributedString, for: .normal)
    }
//        //new user signed in
//   DispatchQueue.global(qos: .userInitiated).async {Auth.auth().addStateDidChangeListener() { auth, user in
//            if user != nil {
//                self.performSegue(withIdentifier: "LoginToHome", sender: nil)
//                self.LoginTextField.text = nil
//                self.PasswordTextField.text = nil
//            }
//            }
    
//   override func viewWillAppear(_ animated: Bool) {
//       super.viewWillAppear(animated)
//       
//       if Auth.auth().currentUser != nil {
//           self.performSegue(withIdentifier: "LoginToHome", sender: self)
//    }
//    }


   override func viewDidAppear(_ animated: Bool) {
       
       if let _ = KeychainWrapper.standard.string(forKey: "uid") {
           
           performSegue(withIdentifier: "LoginToHome", sender: nil)
       }
   }

    // Registration delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegistrationSegue"
        {
             RegisterNewUserReference = segue.destination as? RegisterViewController
             RegisterNewUserReference?.delegate = self
        }
//       if segue.identifier == "LoginToHome"{
//       let tabBarController = segue.destination as! UITabBarController
//        let naviController = tabBarController.viewControllers?.first as! UINavigationController
//        let searchVC = naviController.viewControllers.first as! TableViewUsers
//           searchVC.user = self.newUser
//        
//        }
    }
    
    @IBAction func LoginButtonPressed(_ sender: UIButton)
        {
            if self.LoginTextField.text == "" || self.PasswordTextField.text == "" {
              let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
       
       let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
       alertController.addAction(defaultAction)
       
       self.present(alertController, animated: true, completion: nil)
       
   } else {
       
       Auth.auth().signIn(withEmail: self.LoginTextField.text!, password: self.PasswordTextField.text!) { (user, error) in
           
           if error == nil, user != nil {
            
            // save userId to local library 
            let user = User(uid: (user?.user.uid)!, email: self.LoginTextField.text!)
               self.newUser = user
            KeychainWrapper.standard.set(self.newUser.uid, forKey: "uid")


            
               self.performSegue(withIdentifier: "LoginToHome", sender: nil)
               self.LoginTextField.text = nil
               self.PasswordTextField.text = nil   
               print("You have successfully logged in")
           } else {
               let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
               
               let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
               alertController.addAction(defaultAction)
               
               self.present(alertController, animated: true, completion: nil)
        }
                }
            }
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
extension LoginViewController: RegisterDelegate {
    func registeredNewUser(login: String, password: String) {
        self.LoginTextField.text = login
        self.PasswordTextField.text = password
    }
}



