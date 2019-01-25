//
//  PopUpAssignmentFormViewController.swift
//  StudentHelpApp
//
//  Created by Кирилл on 28.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SwiftKeychainWrapper

class PopUpAssignmentFormViewController: UIViewController {

    @IBOutlet weak var viewPopUp: UIView!
    var user: User!
    var userProfileInfo: UserInfo!
    private var datePicker: UIDatePicker?
    var userImage: String?

    
    @IBOutlet weak var whatToDoTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPopUp.layer.cornerRadius = 12
        viewPopUp.layer.masksToBounds = true
        viewPopUp.layer.borderWidth = 0
        viewPopUp.layer.borderColor = UIColor(white: 231 / 255, alpha: 1).cgColor

        createDatePicker()
        createToolBar()
    }
    
    func createDatePicker()
    {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        deadlineTextField.inputView = datePicker
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        deadlineTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RegisterViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        deadlineTextField.inputAccessoryView = toolBar
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    
    @IBAction func OkButtonPressed(_ sender: UIButton) {
       let userName = Auth.auth().currentUser?.displayName
        let assignment = AssignmentItem(whatToDo: self.whatToDoTextField.text!, subject: self.subjectTextField.text!, addedByUser: userName!, userImage: (self.userProfileInfo?.userImage)!, deadline: self.deadlineTextField.text!, completed: false)
        //JsonWork.JsonWriteAssignments(assignment: assignment)
        //new assignment to Firebase
        let assignmentId = Database.database().reference().child("assignments").childByAutoId().key
        let refAssignments = Database.database().reference(withPath: "assignments").child(assignmentId!)
        let refUserAssignments = Database.database().reference(withPath: "usersInfo").child((self.user?.userId)!).child("assignments").child(assignmentId!)
        refAssignments.setValue(assignment.toAnyObject())
        refUserAssignments.setValue(assignment.toAnyObject())
        //self.removeAnimate()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.5
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
//    func removeAnimate()
//    {
//        UIView.animate(withDuration: 0.25, animations: {
//            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            self.view.alpha = 0.0;
//            }, completion:{(finished : Bool)  in
//                if (finished)
//                {
//                    self.view.removeFromSuperview()
//                }
//        });
//    }
}
@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
