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
                UIPickerViewDataSource,UITextFieldDelegate {
  
  
  @IBOutlet weak var accountType: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var firstName: UITextField!
  @IBOutlet weak var lastName: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var phoneNumber: UITextField!
  
  
  let pickerData = ["User","Add a Shop","professional"]
  var pickerView = UIPickerView()
  var currentIndex = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.hideKeyboardWhenTappedAround()
    
    pickerView.delegate = self
    pickerView.dataSource = self
    accountType.delegate = self
    
    let toolBar = UIToolbar()
    toolBar.barStyle = UIBarStyle.default
    toolBar.isTranslucent = true
    //          toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    toolBar.sizeToFit()
    
    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
    toolBar.setItems([doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    
    accountType.inputView = pickerView
    accountType.inputAccessoryView = toolBar
    
  }
  
  
  @objc func donePicker() {
    accountType.text = pickerData[currentIndex]
    accountType.resignFirstResponder()
  }
  
  
  // Number of columns of data
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  // The number of rows of data
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
  }
  
  // The data to return fopr the row and component (column) that's being passed in
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
  }
  
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    currentIndex = row
    accountType.text = pickerData[row]
    
  }
  
  //
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
    }
  }
  
  // go to the LogIn page
  @IBAction func userHaveAccountTapped(_ sender: Any) {
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = Storyboard.instantiateViewController(identifier: "LogIn")
    vc.modalPresentationStyle = .overFullScreen
    present(vc , animated: true)
  }
  
//  func signIn(){
//
//  }
  
}
