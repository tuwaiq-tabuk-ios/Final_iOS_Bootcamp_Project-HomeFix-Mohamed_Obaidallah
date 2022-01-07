//
//  ProfileVC.swift
//  HouseFix
//
//  Created by محمد العطوي on 25/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase
class ProfileVC: UIViewController {
  
  
  @IBOutlet weak var firstNamePro: UITextField!
  @IBOutlet weak var lastNamePro: UITextField!
  @IBOutlet weak var emailPro: UITextField!
  @IBOutlet weak var phoneNumPro: UITextField!
  @IBOutlet weak var logoutButton: UIButton!
  @IBOutlet weak var updateButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    saveProfile()
  }
  
  
  @IBAction func logoutTouch(_ sender: UIButton) {
    let auth = Auth.auth()
    
    do {
      try auth.signOut()
      self.dismiss(animated: true, completion:nil)
      
    } catch let signOutError {
      let alert = UIAlertController(title: "Error", message: signOutError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  
  func saveProfile () {
    
    let db = Firestore.firestore()
    if let user = Auth.auth().currentUser{
      let id = user.uid
      db.collection("users").document(id).getDocument(completion: { result,
                                                                    error in
        if error != nil{
          print("~~ Error:\(String(describing: error?.localizedDescription))")
        }else{
          if let data = result?.data(){
            self.firstNamePro.text = data["firstName"] as? String
            self.lastNamePro.text = data["lastName"] as? String
            self.phoneNumPro.text = data["phoneNumber"] as? String
          }
        }
      })
      emailPro.text = user.email
    }
  }
  
  
  //MARK: - Update
  @IBAction func UpdateTouch(_ sender: Any) {
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    Auth.auth().currentUser?.updateEmail(to: emailPro.text!, completion: { error in
      if error != nil {
        print("Error Update Email: \(String(describing: error?.localizedDescription))")
      } else {
        UserDefaults.standard.setValue(self.emailPro.text!, forKey: "email")
        UserDefaults.standard.synchronize()
        db.collection("users").document(userID!).setData([
          "firstName": self.firstNamePro.text!,
          "lastName": self.lastNamePro.text!,
          "phoneNumber": self.phoneNumPro.text!,
        ], merge: true)
      }
    })
  }
  
  
}


