//
//  LogInVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 19/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInVC: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwoedTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  
  // View Controller lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    hideKeyboardWhenTappedAround()
    setUpElements()
  }
  
  
  // MARK: - IBAction
  
  @IBAction func logInTapped(_ sender: Any) {
    // Verify Data Entry And Show a Message to The User
    if emailTextField.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwoedTextField.text?
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
      
      logIn(email: emailTextField.text!,
            password: passwoedTextField.text!)
      
    }
  }
  
  
  // go to the SignUp page
  @IBAction func cercteAccountTapped(_ sender: Any) {
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = Storyboard.instantiateViewController(identifier: "SignUp")
    vc.modalPresentationStyle = .overFullScreen
    present(vc , animated: true)
  }
  
  
  // MARK: - Method
  
  func logIn(email:String,password:String) {
    
    Auth.auth()
      .signIn(withEmail: email,
              password: password) { authResult, err in
      if let error = err {
        
        let alert = UIAlertController(title: "Ops!",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok",
                                   style: .cancel,
                                   handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
      } else {
        
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue(password, forKey: "password")
        UserDefaults.standard.synchronize()
        
        getFSCollectionReference(.users)
          .document((authResult?
                      .user.uid)!)
          .getDocument { document, error in
            
            if let err = error {
              print(err.localizedDescription)
            } else {
              let data = document!.data()!
              
              let Storyboard = UIStoryboard(name: "Main", bundle: nil)
              var vc:UIViewController!
              if data["accountType"] as! String == "User"{
                vc = Storyboard.instantiateViewController(identifier: "mainUser")
              } else {
                if data["hasStore"] as! Bool {
                  vc = Storyboard.instantiateViewController(identifier: "mainOrder")
                } else {
                  vc = Storyboard.instantiateViewController(identifier: "mainShop")
                }
              }
              
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc , animated: true)
            }
          }
      }
    }
  }
  
  
  func setUpElements(){
    Utilities.styleTextField(emailTextField)
    Utilities.styleTextField(passwoedTextField)
    Utilities.styleFilledButton(loginButton)
  }
  
}


