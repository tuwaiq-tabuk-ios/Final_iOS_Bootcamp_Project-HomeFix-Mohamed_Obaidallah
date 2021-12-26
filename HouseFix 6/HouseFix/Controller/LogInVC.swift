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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.hideKeyboardWhenTappedAround()
    
  }
  
  
  @IBAction func logInTapped(_ sender: Any) {
    
  }
  
  
  // go to the SignUp page
  @IBAction func cercteAccountTapped(_ sender: Any) {
    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = Storyboard.instantiateViewController(identifier: "SignUp")
    vc.modalPresentationStyle = .overFullScreen
    present(vc , animated: true)
  }
  
  func validateFileds(){
    if email.text?.isEmpty == true{
      print("No Email Text")
      return
    }
    
    if passwoed.text?.isEmpty == true{
      print("No Passwoed ")
      return
    }
  }
  
}

