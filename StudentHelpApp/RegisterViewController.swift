//
//  RegisterViewController.swift
//  StudentHelpApp
//
//  Created by Кирилл on 27.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

protocol RegisterDelegate {
    func registeredNewUser(login: String, password: String)
}

class RegisterViewController: UIViewController {
    
    var delegate: RegisterDelegate?
    let refUserInfo = Database.database().reference(withPath: "usersInfo")

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!    
    @IBOutlet weak var universityNameTextField: UITextField!
    @IBOutlet weak var facultyNameTextField: UITextField!
    @IBOutlet weak var yearOfStudyTextField: UITextField!
    @IBOutlet weak var createPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    let yearsOfStudySelection = ["1(Bachelor)",
                                 "2(Bachelor)",
                                 "3(Bachelor)",
                                 "4(Bachelor)",
                                 "5(Magister)",
                                 "6(Magister)"]
    
    var selectedYear: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPicker()
        createToolBar()
    }
    
    func createPicker() {
        let yearOfStudyPicker = UIPickerView()
        yearOfStudyPicker.delegate = self
        yearOfStudyTextField.inputView = yearOfStudyPicker
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RegisterViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        yearOfStudyTextField.inputAccessoryView = toolBar
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
   if loginTextField.text == "", nameTextField.text == "", yearOfStudyTextField.text == "", createPasswordTextField.text == "", confirmPasswordTextField.text == "" {
       let alertController = UIAlertController(title: "Error", message: "Please fill in all sections", preferredStyle: .alert)
       
       let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
       alertController.addAction(defaultAction)
       present(alertController, animated: true, completion: nil)            
   }
   if createPasswordTextField.text != confirmPasswordTextField.text
       {
           let alertController = UIAlertController(title: "Error", message: "You haven't confirmed password", preferredStyle: .alert)
           
           let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
           alertController.addAction(defaultAction)
           present(alertController, animated: true, completion: nil)
       }
   else {
       Auth.auth().createUser(withEmail: loginTextField.text!, password: createPasswordTextField.text!) { (user, error) in
           
           if error == nil {
               self.delegate?.registeredNewUser(login: self.loginTextField.text!, password: self.createPasswordTextField.text!)
            //User to FireBase
            let userInfo = UserInfo(name: self.nameTextField.text!, universityName: self.universityNameTextField.text!, facultyName: self.facultyNameTextField.text!, yearOfStudy: self.yearOfStudyTextField.text!)
            let userInfoRef = self.refUserInfo.child(self.nameTextField.text!)
            userInfoRef.setValue(userInfo.toAnyObject())
            
            //Local user properties
            LocalUser.Email = self.loginTextField.text!
            LocalUser.Name = self.nameTextField.text!
            LocalUser.UniversityName = self.universityNameTextField.text!
            LocalUser.YearOfStudy = self.yearOfStudyTextField.text!
            LocalUser.FacultyName = self.facultyNameTextField.text!
            
            //Json serialization
            JsonWork.JsonWrite(userinfo: userInfo)
            print("You have successfully signed up")
               
               self.dismiss(animated: true, completion: nil)
               
               
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

// MARK: PickerViewDelegate
 extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearsOfStudySelection.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return yearsOfStudySelection[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedYear = yearsOfStudySelection[row]
        yearOfStudyTextField.text = selectedYear
    }
    
}
