//
//  SignUpVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 19/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpVC: UIViewController {
  
  
  // MARK: - Properties
  
  let typesOfUsers = ["User",
                      "Add a Shop",
                      "professional"]
  
  var pickerView = UIPickerView()
  var currentIndex = 0
  
  
  // MARK: - Outlets
  
  @IBOutlet weak var accountTypeTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var phoneNumberTextField: UITextField!
  @IBOutlet weak var signUpButtonTextField: UIButton!
  @IBOutlet weak var userHaveAccountButton: UIButton!
  @IBOutlet weak var passwordConfirmationTF: UITextField!
  
  
  // MARK: - View Controller lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    hideKeyboardWhenTappedAround()
    setUpElements()
    
    pickerView.delegate = self
    pickerView.dataSource = self
    accountTypeTextField.delegate = self
    
    doneButtonToolBar()
  }
  
  
  // MARK: - Action
  
  @IBAction func signUpTapped(_ sender: Any) {
    signUp()
  }
  
  
  //Go to the LogIn page
  @IBAction func userHaveAccountTapped(_ sender: Any) {
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = Storyboard.instantiateViewController(identifier: "Go_To_LogIn")
    vc.modalPresentationStyle = .overFullScreen
    present(vc , animated: true)
  }
  
  
  // MARK: - Method
  
  private func signUp() {
    
    if emailTextField.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordTextField.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordConfirmationTF.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        firstNameTextField.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        lastNameTextField.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        accountTypeTextField.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        phoneNumberTextField.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == "" {
      
      showAlertMessage(title: "Ops!",
                       message: "Please Fill all the fileds")
      
    }
    
    if passwordTextField.text != passwordConfirmationTF.text {
      
      showAlertMessage(title: "Ops!",
                       message: "Password does not match")
      
    } else {
      Auth
        .auth()
        .createUser(withEmail: emailTextField.text!,
                    password: passwordTextField.text!) { authDataResult, error in
          if error != nil {
            print("error createUser: \(String(describing: error?.localizedDescription))")
            
          } else {
            
            getFSCollectionReference(FSCollectionReference.users)
              .document((authDataResult?.user.uid)!)
              .setData (
                ["firstName" : self.firstNameTextField.text!,
                 "lastName" : self.lastNameTextField.text!,
                 "accountType" : self.accountTypeTextField.text!,
                 "phoneNumber" : self.phoneNumberTextField.text!,
                 "hasStore" : false,
                ]) { error in
                  if error != nil {
                    
                    print("error add User to database: \(String(describing: error?.localizedDescription))")
                  } else {
                    // Specify the account type to show the interface for data entry
                    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                    var vc:UIViewController!
                    if self.accountTypeTextField.text! == "User" {
                      vc = Storyboard.instantiateViewController(identifier: "Go_To_UserPage")
                    } else if self.accountTypeTextField.text! == "Add a Shop" {
                      vc = Storyboard.instantiateViewController(identifier: "Go_To_MainShop")
                    } else {
                      vc = Storyboard.instantiateViewController(identifier: "Go_To_MainShop")
                    }
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc , animated: true)
                  }
                }
          }
        }
    }
    
  }
  
  
  func setUpElements(){
    Utilities.styleTextField(emailTextField)
    Utilities.styleTextField(passwordTextField)
    Utilities.styleTextField(phoneNumberTextField)
    Utilities.styleTextField(accountTypeTextField)
    Utilities.styleTextField(firstNameTextField)
    Utilities.styleTextField(lastNameTextField)
    Utilities.styleFilledButton(signUpButtonTextField)
    Utilities.styleTextField(passwordConfirmationTF)
  }
  
}


// MARK: -UIPickerViewDelegaten And UIPickerViewDataSource And UITextFieldDelegate


extension SignUpVC :  UIPickerViewDelegate,
                      UIPickerViewDataSource,
                      UITextFieldDelegate {
  
  
  // Number of columns of data
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  // The number of rows of data
  func pickerView(_ pickerView: UIPickerView,
                  numberOfRowsInComponent component: Int) -> Int {
    return typesOfUsers.count
  }
  
  // The data to return fopr the row and component (column) that's being passed in
  func pickerView(_ pickerView: UIPickerView,
                  titleForRow row: Int,
                  forComponent component: Int) -> String? {
    return typesOfUsers[row]
  }
  
  
  func pickerView(_ pickerView: UIPickerView,
                  didSelectRow row: Int,
                  inComponent component: Int) {
    currentIndex = row
    accountTypeTextField.text = typesOfUsers[row]
  }
  
  
  func doneButtonToolBar() {
    
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
    
    accountTypeTextField.inputView = pickerView
    accountTypeTextField.inputAccessoryView = toolBar
  }
  
  
  @objc func donePicker() {
    accountTypeTextField.text = typesOfUsers[currentIndex]
    accountTypeTextField.resignFirstResponder()
  }
  
  
}


