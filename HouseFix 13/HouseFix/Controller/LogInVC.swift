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
  
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var passwoed: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    email.text = "mohammed@gmail.com"
    passwoed.text = "12345678"
    
    self.hideKeyboardWhenTappedAround()
    setUpElements()
  }
  
  // Verify Data Entry And Show a Message to The User
  @IBAction func logInTapped(_ sender: Any) {
    if email.text?
        .trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwoed.text?
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
      logIn(email: email.text!, password: passwoed.text!)
    }
  }
  
  
  // go to the SignUp page
  @IBAction func cercteAccountTapped(_ sender: Any) {
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = Storyboard.instantiateViewController(identifier: "SignUp")
    vc.modalPresentationStyle = .overFullScreen
    present(vc , animated: true)
  }
  
  
  // 
  func logIn(email:String,password:String) {
    Auth.auth().signIn(withEmail: email,
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
        let db = Firestore.firestore()
        
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue(password, forKey: "password")
        UserDefaults.standard.synchronize()
        
        db.collection("users")
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
    Utilities.styleTextField(email)
    Utilities.styleTextField(passwoed)
    Utilities.styleFilledButton(loginButton)
  }
  
}


