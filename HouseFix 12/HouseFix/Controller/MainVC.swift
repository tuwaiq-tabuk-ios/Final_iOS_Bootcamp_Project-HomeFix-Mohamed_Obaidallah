//
//  MainVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 19/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class MainVC: UIViewController {
  
  @IBOutlet weak var loginBut: UIButton!
  @IBOutlet weak var signupBut: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpElements()
    
//    let email = UserDefaults.standard.string(forKey: "email")
//    let password = UserDefaults.standard.string(forKey: "password")
//
//    if email != nil && password != nil {
//      logIn(email: email!,
//            password: password!)
//    }
//
  }
  
  
  func logIn(email:String, password:String) {
    Auth.auth().signIn(withEmail: email,
                       password: password) { authResult, err in
      if let error = err {
        // print password wrong or email wrong
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
        UserDefaults.standard.setValue(password, forKey: "passwoed")
        UserDefaults.standard.synchronize()
        
        db.collection("users").document((authResult?.user.uid)!).getDocument { document, error in
          if let err = error {
            print(err.localizedDescription)
          } else {
            let data = document!.data()!
            
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            var vc: UIViewController!
            
            if data["accountType"] as! String == "User"{
              vc = Storyboard.instantiateViewController(identifier: "mainUser")
            } else if data["accountType"] as! String == "Add a Shop" {
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
  
  
  func setUpElements() {
    Utilities.styleHollowButton(loginBut)
    Utilities.styleHollowButton(signupBut)
  }
  
}
