//
//  SignUpVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 19/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpVC: UIViewController,
                UIPickerViewDelegate,
                UIPickerViewDataSource,
                UITextFieldDelegate {
  
  // MARK: - Properties
  
  let typeArray = ["User","Add a Shop","professional"]
  var pickerView = UIPickerView()
  var currentIndex = 0
  
  
  // MARK: - Outlets
  
  @IBOutlet weak var accountType: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var firstName: UITextField!
  @IBOutlet weak var lastName: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var phoneNumber: UITextField!
  @IBOutlet weak var signUpButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.hideKeyboardWhenTappedAround()
    setUpElements()
    
    pickerView.delegate = self
    pickerView.dataSource = self
    accountType.delegate = self
    
    let toolBar = UIToolbar()
    toolBar.barStyle = UIBarStyle.default
    toolBar.isTranslucent = true
    toolBar.sizeToFit()
    
    let doneButton = UIBarButtonItem(title: "Done",
                                     style: UIBarButtonItem.Style.plain,
                                     target: self,
                                     action: #selector(donePicker))
    
    toolBar.setItems([doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    
    accountType.inputView = pickerView
    accountType.inputAccessoryView = toolBar
    
  }
  
  
  @objc func donePicker() {
    accountType.text = typeArray[currentIndex]
    accountType.resignFirstResponder()
  }
  
  // Number of columns of data
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  // The number of rows of data
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return typeArray.count
  }
  
  // The data to return fopr the row and component (column) that's being passed in
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return typeArray[row]
  }
  
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    currentIndex = row
    accountType.text = typeArray[row]
  }
  
  
  // Verify Data Entry And Show a Message to The User
  @IBAction func signUpTapped(_ sender: Any) {
    
    if email.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        password.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        firstName.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        lastName.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        accountType.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        phoneNumber.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == ""
    {
      
      let alert = UIAlertController(title: "Ops!",
                                    message: "Please Fill all the fileds",
                                    preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Ok",
                                 style: .cancel,
                                 handler: nil)
      
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    } else {
      
      Auth.auth().createUser(withEmail: email.text!,
                             password: password.text!) { result, error in
        if error != nil {
          
          print("error createUser: \(error?.localizedDescription)")
        } else {
          let db = Firestore.firestore()
          db.collection("users").document((result?.user.uid)!).setData (
            ["firstName":self.firstName.text!,
             "lastName":self.lastName.text!,
             "accountType":self.accountType.text!,
             "phoneNumber":self.phoneNumber.text!,
             "hasStore":false]) { error in
            if error != nil {
              
              print("error add User to database: \(error?.localizedDescription)")
            } else {
              // Specify the account type to show the interface for data entry
              let Storyboard = UIStoryboard(name: "Main", bundle: nil)
              var vc:UIViewController!
              if self.accountType.text! == "User"{
                vc = Storyboard.instantiateViewController(identifier: "mainUser")
              } else if self.accountType.text! == "Add a Shop" {
                vc = Storyboard.instantiateViewController(identifier: "mainShop")
              } else {
                vc = Storyboard.instantiateViewController(identifier: "mainShop")
              }
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc , animated: true)
            }
          }
        }
      }
    }
  }
  
  //Go to the LogIn page
  @IBAction func userHaveAccountTapped(_ sender: Any) {
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = Storyboard.instantiateViewController(identifier: "LogIn")
    vc.modalPresentationStyle = .overFullScreen
    present(vc , animated: true)
  }
  
  func setUpElements(){
    Utilities.styleTextField(email)
    Utilities.styleTextField(password)
    Utilities.styleTextField(phoneNumber)
    Utilities.styleTextField(accountType)
    Utilities.styleTextField(firstName)
    Utilities.styleTextField(lastName)
    Utilities.styleFilledButton(signUpButton)
  }
  
}
