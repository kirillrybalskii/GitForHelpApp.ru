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
import SwiftKeychainWrapper
import FirebaseStorage

protocol RegisterDelegate {
    func registeredNewUser(login: String, password: String)
}

class RegisterViewController: UIViewController, UINavigationControllerDelegate {
    
    var delegate: RegisterDelegate?
    let refUserInfo = Database.database().reference(withPath: "usersInfo")
    let refUsers = Database.database().reference(withPath: "users")
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var userId: String!
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!    
    @IBOutlet weak var universityNameTextField: UITextField!
    @IBOutlet weak var facultyNameTextField: UITextField!
    @IBOutlet weak var yearOfStudyTextField: UITextField!
    @IBOutlet weak var createPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var userImagePicker: UIImageView!
    
    let yearsOfStudySelection = ["1(Bachelor)",
                                 "2(Bachelor)",
                                 "3(Bachelor)",
                                 "4(Bachelor)",
                                 "5(Magister)",
                                 "6(Magister)"]
    
    var selectedYear: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createImagePicker()
        createPicker()
        createToolBar()
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            
            performSegue(withIdentifier: "toMessage", sender: nil)
        }
    }
    
    func createImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
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
    
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imagePickerPressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
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
            //User profile info to DB
            let additionalInfoRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            additionalInfoRequest?.displayName = self.nameTextField.text!
            additionalInfoRequest?.commitChanges { error in
                if error == nil {
                    print("username saved to Auth")
                    
                 //new user to Firebase(to users and userId/userData)
                self.userId = user!.user.uid
                    self.uploadImg()
                }
            }
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
    func uploadImg() {
        
        guard let img = userImagePicker.image, imageSelected == true else {
            
            print("image needs to be selected")
            
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            
            let metadata = StorageMetadata()
            
            metadata.contentType = "image/jpeg"
            
         Storage.storage().reference().child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                
                if error != nil {
                    
                    print("did not upload img")
                } else {
                    
                    print("uploaded")
                    
                    metadata?.storageReference?.downloadURL(completion: { (url, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        self.userToFirebase(userImageUrl: url!.absoluteString)
                    })
                   
                }
            }
        }
    }
    func userToFirebase(userImageUrl: String) {
        let userInfo = UserInfo(name: self.nameTextField.text!, universityName: self.universityNameTextField.text!, facultyName: self.facultyNameTextField.text!, yearOfStudy: self.yearOfStudyTextField.text!, userImage: userImageUrl)
        KeychainWrapper.standard.set(self.userId!, forKey: "uid")
        let userProfileInfo = self.refUserInfo.child(self.userId!).child("userData")
        userProfileInfo.setValue(userInfo.toAnyObject())
        let systemUsers = self.refUsers.child(self.userId!)
        systemUsers.setValue(userInfo.toAnyObject())
        print("user saved to Firebase")
        //Json serialization
        JsonWork.JsonWrite(userinfo: userInfo)
        print("You have successfully signed up")

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

// MARK: ImagePickerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            userImagePicker.image = image
            
            imageSelected = true
            
        } else {
            
            print("image wasnt selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }

}
